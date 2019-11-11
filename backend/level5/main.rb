require 'json'

require './car'
require './rental'
require './option'

file_input = File.read('./data/input.json')
parsed_input = JSON.parse(file_input)

cars = parsed_input["cars"]
rentals = parsed_input["rentals"]
options = parsed_input["options"]

cars.each do |car|
  Car.new(
    car["id"],
    car["price_per_day"], 
    car["price_per_km"]
  )
end

options.each do |option|
  Option.new(
    option["id"],
    option["rental_id"],
    option["type"]
  )
end

rentals.each do |rental|
  Rental.new(
    rental["id"], 
    rental["car_id"], 
    rental["start_date"], 
    rental["end_date"], 
    rental["distance"], 
    Car.all,
    Option.all
  )
end

Rental.output_rentals_price_data_in_json_file