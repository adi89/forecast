require 'ostruct'

class MockWeatherResponse
  def main
    OpenStruct.new(
      temp: 40,
      feels_like: 20,
      temp_min: 30,
      temp_max: 30
    )
  end

  def name
    "foo"
  end
end
