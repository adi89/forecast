class MockGeoResponse
  attr_reader :success, :zip
  def initialize(success: true, zip: "90210")
    @success = success
    @zip = zip
  end
end
