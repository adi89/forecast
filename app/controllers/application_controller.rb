class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def bad_request(exception)
    render json: {
      error: "Bad Request: #{exception.message}",
      code: 400
    }, status: :bad_request
  end

  def api_client_error(exception)
    render json: {
      error: "Weather API Error: #{exception.message}",
      code: 502
    }, status: :bad_gateway
  end
end
