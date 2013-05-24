require './car2go/car2go'
require 'geokit'
require 'json'

class Location < Car2go
  attr_reader :name, :bounds

  def initialize(name, ne, sw)
    @name = name

    @bounds = Geokit::Bpunds.new(sw, ne)
  end

  def self.load_loacations
    json = JSON.parse(Car2go.getRes('locations', ''))

    cities = []
    json['location'].each do |loc|

      ne = Geokit::LatLng.new(loc['mapSection']['upperLeft']['latitude'], loc['mapSection']['lowerRight']['longitude'])
      sw = Geokit::LatLng.new(loc['mapSection']['lowerRight']['latitude'], loc['mapSection']['upperLeft']['longitude'])
      name = loc['locationName']

      cities.push Location.new(name, ne, sw)
    end

    @@locations = cities
    p "C2G cities: #{cities}"
  end

  def self.locations
    @@locations
  end

  def available?(city)
    @@location.each do |city|

    end
    p "C2G available: #{}}"
    @cities.include?(city.to_s.downcase!)
  end
end