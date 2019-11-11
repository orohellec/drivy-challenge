module CalculService

  def calcul_rental_time_pricing(days, price_per_day)
    total = 0
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

  def calcul_rental_price
    price_per_day = @car.price_per_day
    price_per_km = @car.price_per_km
    distance_price = @distance * price_per_km
    rental_time_price = calcul_rental_time_pricing(@rental_days, price_per_day)
    rental_time_price + distance_price
  end

  def calcul_options_cost
    owner_bonus = 0
    drivy_bonus = 0
    if @options.size > 0 
      @options.each do |option|
        case 
        when option.type == "gps"
          owner_bonus += 500 * @rental_days
        when option.type == "baby_seat"
          owner_bonus += 200 * @rental_days
        when option.type == "additional_insurance" 
          drivy_bonus += 1000 * @rental_days
        end
      end
    end
    option_costs = {owner_bonus: owner_bonus, drivy_bonus: drivy_bonus}
  end

  def calcul_actors_to_debit_or_credit(rental_price, options_amount)
    commissions_fee = (rental_price * 0.3).to_i
    driver_debit = rental_price + options_amount[:owner_bonus] + options_amount[:drivy_bonus]
    owner_credit = (rental_price * 0.7).to_i + options_amount[:owner_bonus]
    insurance_fee =  (commissions_fee / 2).to_i
    assistance_fee = @rental_days * 100
    drivy_fee = commissions_fee - insurance_fee - assistance_fee + options_amount[:drivy_bonus]

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