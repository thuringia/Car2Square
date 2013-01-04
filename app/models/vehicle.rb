class Vehicle
  require "json"

  def initialize(address,coordinates,fuel,name,vin)
    @address = address
    @coordinates = coordinates
    @fuel = fuel
    @name = name
    @vin = vin
  end

  def parse_json(json)
    obj = JSON.parse json
    cars = obj["placemarks"].each do |address,coordinates,fuel,name,vin|
      new Vehicle(address,coordinates,fuel,name,vin)
    end
  end
end