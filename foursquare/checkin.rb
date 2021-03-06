require 'geokit'

class Checkin
  attr_reader :c_id, :u_id, :city, :lat, :long, :ll

  def initialize(json)
    checkin_obj = JSON.parse(json)

    @c_id = checkin_obj['id'].to_s
    @u_id = checkin_obj['user']['id'].to_s

    venue_loc = checkin_obj['venue']['location']
    @city = venue_loc['city'].to_s
    @lat = venue_loc['lat']
    @long = venue_loc['lng']
    @ll = Geokit::LatLng.new(@lat, @long)
  end

  def ll
    return @ll
  end
end