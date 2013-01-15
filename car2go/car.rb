class Car
  attr_reader :address, :ll ,:name

  def initialize(json)
    obj = JSON.parse(json)
    gps = obj[:coordinates]

    @address = obj[:address]
    @ll = [gps[0],gps[1]]
    @name = obj[:name]
  end
end