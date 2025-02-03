Thread.current[:weather_client] = OpenWeather::Client.new(
  api_key: ENV['WEATHER_API_KEY']
)
