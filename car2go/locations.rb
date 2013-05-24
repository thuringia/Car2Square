require './car2go/car2go'
require 'geokit'
require 'json'

class Location < Car2go
  attr_reader :name, :bounds

  def initialize(name, ne, sw)
    @name = name

    @bounds = Geokit::Bounds.new(sw, ne)
  end

  def self.load_locations
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

  def self.available?(ll)
    @@locations.each do |city|
      p "C2G available in #{city.name}: #{city.bounds.contains?(ll)}"
      ret = false unless city.bounds.contains?(ll)
      if ret
        return ret
      end
    end
    return false
  end
end