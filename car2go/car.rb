class Car
  attr_reader :address, :lat, :long ,:name

  def initialize(json)
    obj = JSON.parse(json)
    gps = obj[:coordinates]

    @address = obj[:address]
    @lat = gps[0]
    @long = gps[1]
    @name = obj[:name]
  end
end