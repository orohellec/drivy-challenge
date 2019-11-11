require_relative '../rental'
require_relative '../car'
require_relative '../option'

car_one = Car.new(1, 2000, 10)
car_two = Car.new(2, 3000, 15)
option_one = Option.new(1, 1, "gps")
option_two = Option.new(2, 1, "baby_seat")
rental = Rental.new(1, 1, "2017-12-8", "2017-12-10", 100, Car.all, Option.all)
rental_two = Rental.new(1, 2, "2017-12-14", "2017-12-18", 100, Car.all, Option.all)

describe Rental do
  describe "class methods" do
    subject {Rental}

    it "expect self.all to be valid" do 
      expect(subject.all).to eq([rental, rental_two])
    end
  end

  describe "instances methods" do
    subject {rental}

    it "expect resume to be valid" do
      expect(subject.resume)
        .to eq({
          id: 1,
          options: [
            "gps",
            "baby_seat"
          ],
          actions: [
            {
              who: "driver",
              type: "debit",
              amount: 8700
            },
            {
              who: "owner",
              type: "credit",
              amount: 6720
            },
            {
              who: "insurance",
              type: "credit",
              amount: 990
            },
            {
              who: "assistance",
              type: "credit",
              amount: 300
            },
            {
              who: "drivy",
              type: "credit",
              amount: 690
            }
          ]
        })
    end
  end

  describe 'private instances methods' do
    subject {rental}

    it "expect to have one associated car" do 
      expect(subject.car).to eq(car_one)
    end
    it "expect calcul_rental_days to be valid" do
      expect(subject.send(:rental_days, "2015-03-31", "2015-04-1")).to eq(2)
    end
    it "expect calcul_total_price to be valid" do
      expect(subject.send(:rental_price)).to eq(6600)
    end
  end
end