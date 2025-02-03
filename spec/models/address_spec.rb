require 'rails_helper'

describe Address do
  subject { described_class.new(address) }

  before do
    allow(Geokit::Geocoders::GoogleGeocoder).to receive(:geocode).and_return(geo_response)
  end

  context 'when address is valid' do
    let(:address){ "123 main street, princeton, nj" }
    let(:geo_response){ MockGeoResponse.new }

    it 'returns a zip' do
      expect(subject.zip).to eq('90210')
    end
  end

  context 'when address is invalid' do
    let(:address){ "mumbo jumbo" }
    let(:geo_response){ MockGeoResponse.new(success: false, zip: nil )}

    it 'raises invalid Address Error' do
      expect { subject }.to raise_error(AddressInvalidError)
    end
  end
end
