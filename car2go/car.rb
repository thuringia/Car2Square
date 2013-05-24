require './car2go/car2go'
require 'geokit'
require 'json'

class Car < Car2go
  attr_reader :address, :ll ,:name, :distance
  attr_writer :address, :ll ,:name, :distance

  @@cars = []

  def initialize(name, address, lat, long)
    @address = address
    @ll = Geokit::LatLng.new(lat, long)
    @name = name
  end

  def calculate_distance(from_ll)
    p "car #{@name} from #{from_ll} to #{@ll}"
    @distance = Geokit::LatLng.distance_between(from_ll, @ll, :units => :kms)
  end

  def self.load_cars(city)
    cars = JSON.parse(Car2go.getRes('vehicles', "&loc=#{city}"))

    unless cars['placemarks'].empty?
      cars['placemarks'].each do |c2g|
        @@cars.push Car.new(c2g['name'], c2g['address'], c2g['coordinates'][1], c2g['coordinates'][0])
      end
    end
    return @@cars
  end
end