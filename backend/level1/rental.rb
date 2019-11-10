require 'date'

require './modules/helper_module'

class Rental
  extend HelperModule

  attr_reader :car

  @@instances = []
  @@output_data = {
    rentals: []
  }

  def initialize(id, car_id, start_date, end_date, distance, cars)
    @id = id
    @car_id = car_id
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
    @car = has_one_car(cars)
    @@instances << self
  end

  def self.all
    @@instances
  end

  def self.output_rentals_price_data_in_json_file
    all.each do |rental|
      @@output_data[:rentals] << rental.resume
    end
    outpout_file = 'my_output.json'
    write_outpout_in_json_file(outpout_file, @@output_data)
  end

  def resume
    {id: @id, price: calcul_total_price}
  end

  private

  def has_one_car(cars)
    car = cars.select { |car|  car.id == @car_id }
    car[0]
  end

  def calcul_rental_days
    (@end_date - @start_date).to_i + 1
  end
  
  def calcul_total_price
    rental_days = calcul_rental_days
    price_per_day = @car.price_per_day
    price_per_km = @car.price_per_km
    rental_days * price_per_day + @distance * price_per_km
  end
end