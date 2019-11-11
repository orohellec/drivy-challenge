require 'date'

require './modules/helper_module'
require './service/calcul_service'

class Rental
  extend HelperModule
  include CalculService

  attr_reader :car

  @@instances = []
  @@output_data = {
    rentals: []
  }

  def initialize(id, car_id, start_date, end_date, distance, cars, options)
    @id = id
    @car_id = car_id
    @rental_days = rental_days(start_date, end_date)
    @distance = distance
    @car = has_one_car(cars)
    @options = has_many_options(options)
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
    actions = actors_to_debit_or_credit(rental_price, options_cost)
    options = @options.map { |option| option.type }
    {id: @id, options: options, actions: actions}
  end

  private

  def has_one_car(cars)
    car = cars.select { |car|  car.id == @car_id }
    car[0]
  end

  def has_many_options(options)
    associated_options = options.select { |option| option.rental_id == @id }
  end

  def rental_days(start_date, end_date)
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end
  
  def rental_price
    calcul_rental_price
  end

  def options_cost
    calcul_options_cost
  end

  def actors_to_debit_or_credit(total_price, options_amount)
    calcul_actors_to_debit_or_credit(total_price, options_amount)
  end
end