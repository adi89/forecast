class WeatherForecast
  UNITS = "imperial"

  def initialize(zip:)
    @zip = zip
  end

  def to_h
    {
      name: query.name,
      temperature: query.main.temp,
      feels_like: query.main.feels_like,
      min: query.main.temp_min,
      max: query.main.temp_max
    }
  end

  private

  attr_reader :zip

  def query
   @query ||= weather_client.current_weather(zip: zip, units: UNITS)
  rescue => e
    raise ClientApiError.new("Error: #{e.message}")
  end

  def weather_client
    OpenWeather::Client.new(api_key: ENV["WEATHER_API_KEY"])
  end
end

class ClientApiError < StandardError; end
