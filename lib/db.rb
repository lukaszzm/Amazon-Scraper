require 'sequel'

module Database
  class << self
    def connect_and_initialize
      puts "Connecting to in-memory DB..."
      @db = Sequel.sqlite

      @db.create_table(:products) do
        primary_key :id
        String :name
        String :url
        String :price
        String :description
        String :rating_score
        String :rating_count
      end

      @products = @db[:products]
      puts "Connected"
    end

    def disconnect
      puts "Disconnecting from in-memory DB"
      @db&.disconnect
    end

    def find_all
      @products.all
    end

    def find_by_id(id)
      @products[id: id]
    end

    def insert(product)
      puts "Product saved to database"
      @products.insert(product)
    end

    def update(name, data)
      puts "Product updated"
      @products.where(name: name).update(data)
    end

    def delete(id)
      puts "Product deleted"
      @products.where(id: id).delete
    end

    def print
      @products.all.each do |product|
        puts "-----------------------------------------------"
        puts "Product name: " + product[:name]
        puts "Product url: " + product[:url]
        puts "Product price: " + product[:price]
        puts "Product description: " + product[:description]
        puts "Product rating score: " + product[:rating_score]
        puts "Product ratings: " + product[:rating_count]
        puts "-----------------------------------------------"
      end
    end
  end
end

