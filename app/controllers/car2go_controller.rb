class Car2goController < ApplicationController
  @@locations=['amsterdam','austin','berlin','birmingham','calgary','dusseldorf','hamburg','cologne','london','miami',
  'portland','san diego', 'seattle', 'stuttgart','toronto','ulm','vancouver', 'dc', 'vienna']

  def auth(usr)

  end

  def has_c2g?(checkin)
    ret = false
    @@locations.each do |area|
      checkin[city].eql?(area) ? ret = true : ret = false
      break if ret
    end
    return ret
  end
  
  def vehicles(fsq_token, checkin)
    usr = User.find_all_by_fsq_token(fsq_token)
    if usr
      response = HTTParty.get("http://www.car2go.com/api/v2.1/vehicles?loc=austin&oauth_consumer_key="+@@api_key+"&format=json")
      cars = Vehicle.parse_json(response)
    end
  end
end
