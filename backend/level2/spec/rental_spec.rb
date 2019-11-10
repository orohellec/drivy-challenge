require_relative '../rental'
require_relative '../car'

car_one = Car.new(1, 2000, 10)
car_two = Car.new(2, 3000, 15)
rental = Rental.new(1, 1, "2017-12-8", "2017-12-10", 100, Car.all)
rental_two = Rental.new(1, 2, "2017-12-14", "2017-12-18", 100, Car.all)

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
      expect(subject.resume).to eq({id: 1, price: 6600})
    end
  end

  describe 'private instances methods' do
    subject {rental}

    it "expect to have one associated car" do 
      expect(subject.car).to eq(car_one)
    end
    it "expect calcul_rental_days to be valid" do
      expect(subject.send(:calcul_rental_days)).to eq(3)
    end
    it "expect calcul_total_price to be valid" do
      expect(subject.send(:calcul_total_price)).to eq(6600)
    end
  end
end