require './car2go/car2go'
require 'geokit'
require 'json'

class Car < Car2go
  attr_reader :address, :ll ,:name, :distance
  attr_writer :address, :ll ,:name, :distance

  @@cars = []

  def initialize(name, address, ll)
    @address = address
    @ll = ll
    @name = name
  end

  def calculate_distance(from_ll)
    @distance = Geokit::Mappable.distance_between(from_ll, @ll, :units => :kms)
    p "distance: #{@distance}"
  end

  def self.load_cars(city)
    cars = JSON.parse(Car2go.getRes('vehicles', "&loc=#{city}"))

    unless cars['placemarks'].empty?
      cars['placemarks'].each do |c2g|
        @@cars.push Car.new(c2g['name'], c2g['address'], [c2g['coordinates'][0], c2g['coordinates'][1]])
      end
    end
  end
end