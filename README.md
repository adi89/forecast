# Forecast
## _Gee, what's the weather outside?_



### Overview

- Input an Address
- See a forecast and plan accordingly
- Voilà

To see this in action you must:
* Create an API key for [Open Weather API](https://home.openweathermap.org/api_keys)
* Create an API key for [Google Maps](https://developers.google.com/maps/documentation/geocoding/get-api-key)
* SET `WEATHER_API_KEY` and `GEO_API_KEY` in your `.env` file at the root of your app

## Notes

- Forecasts for zipcodes are cached for 30 minutes per specification.

- Behind the scenes, we're leveraging Google's Geokit API to convert the addresses into zipcodes.

    - Why?
      - Because OpenWeather doesn't accept addresses in a friendly format to their API. Geokit lets us have expanded infor and keeps things consistent.

- The main players are [`WeatherForecast`](https://github.com/adi89/forecast/blob/main/app/models/weather_forecast.rb) and [`Address`]https://github.com/adi89/forecast/blob/main/app/models/address.rb). The conventional route is inputting an address, hitting submit, and that taking you to [`post#weather_forecasts`](https://github.com/adi89/forecast/blob/main/app/controllers/weather_forecasts_controller.rb). From there, we fetch weather data via OpenWeather API (supplemental address data via GeoKit), format it, and display it on a container on the index. Pretty straightforward.

__To DO__(at some point):
- move `OpenWeather::Client` (untether) to a singleton
- Refine errors to provide greater specificity and find all possible error states
- Metric friendly weather for folks outside of the USA
- `Redis` for storing cached data (so separate connections can access the same address data saving on the API calls.. to an extent)
- Update the UI from the 1995 aesthetic
- Potentially have a separate class for formatting the Forecast from fetching the data
