
require_relative 'lib/db'
require_relative 'lib/crawler'

String BASE_URL = "https://www.amazon.com"

String ENDPOINT = "/s?i=specialty-aps&bbn=4954955011&rh=n%3A4954955011%2Cn%3A%212617942011%2Cn%3A12896841&ref=nav_em__nav_desktop_sa_intl_fabric_decorating_0_2_8_6"
String KEYWORDS = ""

puts "Starting..."

Database.connect_and_initialize
Crawler.initialize_driver BASE_URL

products = Crawler.search_products(ENDPOINT, KEYWORDS)

products.each { |product|
  product_with_details = Crawler.fetch_product_details(product)
  Database.insert(product_with_details)
}

Database.print

Database.disconnect
Crawler.close_driver
puts "Done, exiting..."