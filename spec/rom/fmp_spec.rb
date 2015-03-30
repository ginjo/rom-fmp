require 'spec_helper'

describe ROM::FMP do
  it 'has a version number' do
    expect(ROM::FMP::VERSION).not_to be nil
  end

  it 'loads ginjo-rfm gem ~> 3.0' do
    expect(Rfm::VERSION.major).to eq('3')
    expect(Rfm::VERSION.minor).to eq('0')
  end
end
