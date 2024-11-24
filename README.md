
<h3 align="center">Amazon Scraper</h3>

  <p align="center">
    Ruby-based Amazon page scraper
  </p>

## About The Project

A Ruby-based web scraper that utilizes Nokogiri and Selenium to extract product information from Amazon websites, 
which also includes a database helper for saving the retrieved product data.

## Features

- Extract product information based on keywords
- Store and retrieve details from SQLite Database

## How To Use

1. Install required packages:
```
bundle install
```
2. Provide your **endpoint** to amazon website or stick to the default one. (main.rb file)
3. Enter your **keywords**, or leave the field blank to allow the scraper to fetch products from the specified endpoint. (main.rb file)
4. Run scraper and wait for results.

## Important Notes

Sometimes the scraper does not work because the product structure varies or the internet connection is weak. 
If this happens, try using a different endpoint or keywords. You can also limit the number of products fetched in the `search_products` function.
