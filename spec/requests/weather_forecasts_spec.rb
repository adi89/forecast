require 'rails_helper'

RSpec.describe "Weather Forecasts", type: :request do
  describe "GET /index" do
    before { get "/" }

    it "Returns a 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST /weather_forecasts" do
    context "given an unsuccessful request" do
      context "given an invalid address" do
        before do
          allow(Address).to receive(:new).and_raise(AddressInvalidError)
        end

        before { post "/weather_forecasts", params: { address: "invalid" }, as: :turbo_stream }

        it "returns a bad request" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context "given an error in the forecast api" do
        let(:mock_address) { OpenStruct.new(zip: '90210') }

        before do
          allow(Address).to receive(:new).and_return(mock_address)
          expect(Rails.cache).to receive(:read).and_return(false)
          allow(WeatherForecast).to receive(:new).and_raise(WeatherClientApiError)
        end

        before { post "/weather_forecasts", params: { address: "123 york street" }, as: :turbo_stream }

        it "returns a bad gateway request" do
          expect(response).to have_http_status(:bad_gateway)
        end
      end
    end

    context "given a successful request" do
      let(:mock_address) { OpenStruct.new(zip: '90210') }

      before do
        allow(Address).to receive(:new).and_return(mock_address)
        allow(Rails.cache).to receive(:read).and_return(cached)
      end

      context "when cache has not been hit" do
        let(:cached) { nil }
        before do
          allow(Rails.cache).to receive(:fetch).and_return({})
        end

        before { post "/weather_forecasts", params: { address: "123 york street" }, as: :turbo_stream }

        it 'returns a 201' do
          expect(response.status).to eq(200)
        end
      end


      context "when cache has been hit" do
        let(:cached) { {
          name: "foo",
          temperature: 59,
          feels_like: 50,
          min: 23,
          max: 60
        }}

        before { post "/weather_forecasts", params: { address: "123 york street" }, as: :turbo_stream }

        it 'returns a 201' do
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
