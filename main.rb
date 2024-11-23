require 'nokogiri'
require 'open-uri'
require 'selenium-webdriver'

# TODO:
# 1. Pobieranie informacji z podstron każdego produktu
# 2. Zapisywanie informacji w bazie danych

X_KOM_URL = "https://www.x-kom.pl/g-5/c/346-karty-graficzne-nvidia.html"

KEYWORDS = 'procesor intel'

Product = Struct.new(:href, :name, :price)

puts "Starting..."

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument("--window-size=1920,1080")
driver = Selenium::WebDriver.for :chrome, options: options

driver.navigate.to X_KOM_URL

wait = Selenium::WebDriver::Wait.new(timeout: 10)
wait.until { driver.find_element(:xpath, "//button[@data-name='AcceptPermissionButton']")}

driver.find_element(:xpath,"//button[@data-name='AcceptPermissionButton']").click

unless KEYWORDS.empty?
  driver.find_element(:xpath,"//input[@placeholder='Czego szukasz?']").send_keys(KEYWORDS)
  driver.find_element(:css,'.parts__ButtonIcon-sc-5792957c-6').click
  wait.until { driver.find_element(:xpath, "//div[@data-name='productCard']")}
end


document = Nokogiri::HTML(driver.page_source)

html_products = document.xpath("//div[@data-name='productCard']")
products = []

html_products.each do |product|
  # The first 'a' tag is an image
  heading = product.css('a')[1]

  name = heading.css('h3').text
  href = heading['href']

  # sale -> two prices are displayed
  price = product.css(".parts__Price-sc-6e255ce0-0").first.text

  found_product = Product.new(href, name, price)
  products.push(found_product)
end

products_details = []




puts "Done!"
driver.quit