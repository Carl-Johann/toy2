require 'json'
def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    $report_file = File.new("report.txt", "w+")
end

# Print "Sales Report" in ascii art
def AsciiArt (art)
	if art == "products"
		puts "                     _            _       "
		puts "                    | |          | |      "
		puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
		puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
		puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
		puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
		puts "| |                                       "
		puts "|_|        "
	end	
end


# Print today's date
def date
	time = Time.new
	$report_file.puts "Todays date: #{time.day}/#{time.month} - #{time.year}"
end
# Print "Products" in ascii art
def ascii_sales_report
		$report_file.puts"           _                                     _   "
		$report_file.puts"	  | |                                   | |  "
		$report_file.puts" ___  __ _| | ___  ___ _ __ ___ _ __   ___  _ __| |_ "
		$report_file.puts"/ __|/ _` | |/ _ \\/ __| '__/ _ \\ '_ \\ / _ \\| '__| __|"
		$report_file.puts"\\__ \\ (_| | |  __/\\__ \\ | |  __/ |_) | (_) | |  | |_"
		$report_file.puts"|___/\\__,_|_|\\___||___/_|  \\___| .__/ \\___/|_|   \\__|"
		$report_file.puts"		               | |                   "
		$report_file.puts"		               |_|                   "
end
# For each product in the data set:
	# Print the name of the toy
def title(variabel)
	variabel["title"]
end
	# Print the retail price of the toy
def retail_price(variabel) 
	variabel["full-price"]
end
	# Calculate and print the total number of purchases
def number_purchases(variabel)
	variabel["purchases"].length
end
	# Calculate and print the total amount of sales
def totalsales(variabel)
	prices = 0
	variabel["purchases"].each {|pris| prices+= pris["price"]}
	prices
end
	# Calculate and print the average price the toy sold for
def avg_price(variabel, priser)
	priser/variabel
end
	# Calculate and print the average discount (% or $) based off the average sales price
def avg_discount(full_price, prices, length)
	full_price.to_f - (prices.to_f/length.to_f)
end	
	# Print "Brands" in ascii art
def brands
		$report_file.puts " _                         _     "
		$report_file.puts "| |                       | |    "
		$report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
		$report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
		$report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
		$report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
		$report_file.puts 
end
# For each brand in the data set:
	# Print the name of the brand
def unique_brands
	$products_hash["items"].map{ |product| product["brand"] }.uniq
end
	# Count and print the number of the brand's toys we stock
def amount_products(brand, lort = {})
	$products_hash["items"].each do |toy|
		if toy["brand"] == brand
			lort[:counter] += toy["stock"]
		end
	end
	$report_file.puts "Amount of Products: #{lort[:counter]}"
end
	# Calculate and print the average price of the brand's toys
def avg_price_brand(brand, options = {})
	$products_hash["items"].each do |toy|
		if toy["brand"] == brand
			options[:counter] += 1
			options[:average_price] += toy["full-price"].to_f
		end
	end
	avgPrice = (options[:average_price]/options[:counter]).round(2)
	$report_file.puts "Average Product Price: $#{avgPrice}" 
end
	# Calculate and print the total sales volume of all the brand's toys combined
def total_sales(brand, options = {})
	$products_hash["items"].each do |toy|
		if toy["brand"] == brand
			toy["purchases"].each do |purchase|
				options[:counter] += purchase["price"].to_f
			end
		end	
	end
	$report_file.puts "Total Sales: $#{options[:counter].round(2)}"
end	


def create_report 
	date
	$report_file.puts ascii_sales_report
	$products_hash["items"].each do |toy|
		$report_file.puts title(toy)
		$report_file.puts "*"*27
		$report_file.puts "Retail Price: $#{retail_price(toy)}"
		$report_file.puts "Total Purchases: #{number_purchases(toy)}"
		$report_file.puts "Total Sales: $#{totalsales(toy)}"
		$report_file.puts "Average price: $#{avg_price(number_purchases(toy), totalsales(toy))}"
		$report_file.puts "Average discount: $#{avg_discount(retail_price(toy), totalsales(toy), number_purchases(toy))}"
		$report_file.puts
	end
	brands
	unique_brands.each do |brand|
		stock_counter = 0
		product_counter = 0
		average_price = 0
		price_sum = 0
		$report_file.puts brand.upcase
		$report_file.puts "*"*27
		amount_products brand, counter:stock_counter
		avg_price_brand brand, counter:product_counter, average_price:average_price
		total_sales brand, counter:price_sum
		$report_file.puts
	end
end


def start 
	setup_files
	create_report
end	

start