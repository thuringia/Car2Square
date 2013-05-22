require './car2go/car2go'
require 'geokit'
require 'json'

class Locations < Car2go
  attr_reader :cities

  def initialize
    json = JSON.parse(Car2go.getRes('locations', ''))

    cities = []
    json['location'].each do |loc|
      cities.push loc['locationName'].to_s.downcase!
    end

    @cities = cities
    logger.info "C2G cities: #{@cities}"
  end

  def available?(city)
    logger.info "C2G available: #{@cities.include?(city.to_s.downcase!)}"
    false unless @cities.include?(city.to_s.downcase!)
  end
end