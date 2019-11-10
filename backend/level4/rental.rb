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
    @rental_days = calcul_rental_days(start_date, end_date)
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
    total_price = calcul_total_price
    actions = actors_to_debit_or_credit(total_price)
    {id: @id, price: total_price, actions: actions}
  end

  private

  def has_one_car(cars)
    car = cars.select { |car|  car.id == @car_id }
    car[0]
  end

  def calcul_rental_days(start_date, end_date)
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  def calcul_rental_time_pricing(days, price_per_day)
    total = 0
    multiplicator = 1
    day = 1
    while day <= days
      total += price_per_day if day == 1
      total += price_per_day * 0.9 if (day > 1 && day <= 4)
      total += price_per_day * 0.7 if (day > 4 && day <= 10)
      total += price_per_day * 0.5 if day > 10
      day += 1
    end
    total.to_i
  end
  
  def calcul_total_price
    price_per_day = @car.price_per_day
    price_per_km = @car.price_per_km
    distance_price = @distance * price_per_km
    rental_time_price = calcul_rental_time_pricing(@rental_days, price_per_day)
    rental_time_price + distance_price
  end

  def actors_to_debit_or_credit(total_price)
    commissions_fee = (total_price * 0.3).to_i
    driver_debit = total_price
    owner_credit = (total_price * 0.7).to_i
    insurance_fee =  (commissions_fee / 2).to_i
    assistance_fee = @rental_days * 100
    drivy_fee = commissions_fee - insurance_fee - assistance_fee

    actions = [
      {
        who: "driver",
        type: "debit",
        amount: driver_debit
      },
      {
        who: "owner",
        type: "credit",
        amount: owner_credit
      },
      {
        who: "insurance",
        type: "credit",
        amount: insurance_fee
      },
      {
        who: "assistance",
        type: "credit",
        amount: assistance_fee
      },
      {
        who: "drivy",
        type: "credit",
        amount: drivy_fee
      }
    ]
  end
end