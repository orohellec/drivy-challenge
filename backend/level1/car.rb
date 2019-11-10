class Car
  attr_reader :id, :price_per_km, :price_per_day

  @@instances = []

  def initialize(id, price_per_day, price_per_km)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
    @@instances << self
  end

  def self.all
    @@instances
  end
end