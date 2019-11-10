require 'json'

require './car'
require './rental'

input_file = File.read('./data/input.json')
input_hash = JSON.parse(input_file)

input_cars = input_hash["cars"]
input_rentals = input_hash["rentals"]

input_cars.each do |car|
  Car.new(
    car["id"],
    car["price_per_day"], 
    car["price_per_km"]
  )
end

input_rentals.each do |rental|
  Rental.new(
    rental["id"], 
    rental["car_id"], 
    rental["start_date"], 
    rental["end_date"], 
    rental["distance"], 
    Car.all
  )
end

Rental.output_rentals_price_data_in_json_file











