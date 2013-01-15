require 'sinatra'
require './car2go/car2go'
require 'geokit'

class Locations < Car2go
  attr_reader :cities

  def initialize
    json = JSON.parse(Car2go.getRes('locations', ''))
    cities = []
    logger.info json[:location]
    json[:location].each do |loc|
      cities.push loc[:locationName].to_s.downcase!
    end

    @cities = cities
  end

  def available?(city)
    false unless @cities.include?(city.to_s.downcase!)
  end

  def near?(city, cars)

  end
end