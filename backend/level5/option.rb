class Option
  attr_reader :id, :rental_id, :type, :price

  @@instances = []

  def initialize(id, rental_id, type)
    @id = id
    @rental_id = rental_id
    @type = type
    @@instances << self
  end

  def self.all
    @@instances
  end
end