class WeatherForecastsController < ApplicationController
  rescue_from ::AddressInvalidError, with: :bad_request
  rescue_from ::WeatherClientApiError, with: :api_client_error
  
  def index
  end

  def create
    zip = Address.new(address_params[:address]).zip
    cached = Rails.cache.read(zip)

    @weather_forecast = {
      data: cached || cache_forecast(zip),
      cached: cached.present?
    }

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "weatherContainer", #container in index.html.erb
          partial: "forecast",
          locals: @weather_forecast
        )
      end
    end
  
  end

  private

  def address_params
    params.permit(:address)
  end

  def cache_forecast(zip)
    Rails.cache.fetch(zip, expires_in: 30.minutes) {
      WeatherForecast.new(zip: zip).to_h
    }
  end

end
