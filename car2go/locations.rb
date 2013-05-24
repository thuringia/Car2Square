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
  end

  def self.locations
    @@locations
  end

  def self.available?(ll)
    @@locations.each do |city|
      if city.bounds.contains?(ll)
        return city.name
      end
    end
    return ''
  end
end