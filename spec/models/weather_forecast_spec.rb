require 'rails_helper'

describe WeatherForecast do
  subject { described_class.new(zip: zip) }

  before do
    allow_any_instance_of(described_class).to receive(:weather_client)
      .and_return(weather_client)
  end

  let(:weather_client){ double('weather_client') }
  let(:mock_weather_response){ MockWeatherResponse.new }
  let(:zip){ '90210' }
  
  context 'when weather forecast is valid' do
    before do
      allow(weather_client).to receive(:current_weather).and_return(mock_weather_response)
    end

    let(:expected_forecast){
      {
        temperature: 40,
        feels_like: 20,
        min: 30,
        max: 30,
        name: "foo"
      }
    }

    it 'returns a hash with temperature forecast data' do
      expect(subject.to_h).to eq(expected_forecast)
    end
  end
  
  context 'when weather forecast is invalid' do
    before do
      allow(weather_client).to receive(:current_weather).and_raise
    end
  
    let(:mock_weather_response){ raise }

    it 'raises ClientApiError' do
      expect { subject.to_h }.to raise_error(ClientApiError) 
    end
  end

end
