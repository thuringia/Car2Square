require 'geokit'

class Car
  attr_reader :address, :ll ,:name, :distance

  def initialize(obj)
    gps = obj['coordinates']

    @address = obj['address']
    @ll = [gps[0],gps[1]]
    @name = obj['name']
  end

  def distance(from_ll)
    @distance = Geokit::Mappable.distance_between(from_ll, @ll, :units => :kms)
  end

  def self.free?(city)
    cars = JSON.parse(Car2go.getRes('vehicles', "&loc=#{city}"))

    (cars['placemarks'].empty?) ? [] : cars['placemarks']
  end
end