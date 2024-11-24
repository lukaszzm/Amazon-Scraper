require 'nokogiri'
require 'open-uri'
require 'selenium-webdriver'

module Crawler
  class << self
    def initialize_driver(base_url, headless: true)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--window-size=1920,1080")
      options.add_argument("--headless") if headless

      @base_url = base_url
      @driver = Selenium::WebDriver.for :chrome, options: options
      @wait = Selenium::WebDriver::Wait.new(timeout: 10)
    end

    def close_driver
      @driver&.quit
    end

    def search_products(endpoint, keywords = "", limit = 5)
      @driver.navigate.to @base_url + endpoint

      unless keywords.empty?
        search_box = @driver.find_element(:css, "#twotabsearchtextbox")
        search_box.send_keys(keywords)
        @driver.find_element(:css, '#nav-search-submit-button').click
      end

      @wait.until { @driver.find_element(:xpath, "//span[@data-csa-c-type='item']") }
      document = Nokogiri::HTML(@driver.page_source)

      html_products = document.xpath("//span[@data-csa-c-type='item']")
      limited_html_products = html_products.slice(0, limit)

      products = []
      limited_html_products.each do |product|
        title = product.css("h2").text.strip
        href = product.css("h2 a").attribute("href").value
        whole = product.css('.a-price-whole').text.strip
        fraction = product.css('.a-price-fraction').text.strip
        symbol = product.css(".a-price-symbol").text.strip
        price = symbol + whole + fraction

        products << { href: href, name: title, price: price }
      end

      products
    end

    def fetch_product_details(product)
        @driver.navigate.to @base_url + product[:href]
        @wait.until { @driver.find_element(:css, "#productTitle") }

        document = Nokogiri::HTML(@driver.page_source)

        desc = document.css("#feature-bullets li").map(&:text).first
        rating_score = document.css("#averageCustomerReviews .a-popover-trigger span").first&.text
        rating_count = document.css("#acrCustomerReviewText").first&.text

        {
          name: product[:name],
          url: @base_url + product[:href],
          price: product[:price],
          description: desc,
          rating_score: rating_score,
          rating_count: rating_count
        }
    end
  end
end

