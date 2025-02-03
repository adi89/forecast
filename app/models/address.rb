class Address
  def initialize(address)
    @address = _query(address)
  end

  def zip
    address.zip
  end

  private

  attr_reader :address

  def _query(address)
    address = Geokit::Geocoders::GoogleGeocoder.geocode(address)
    raise AddressInvalidError.new unless address.success
    address
  end

end

class AddressInvalidError < StandardError; end
