require 'spec_helper'

require 'rom/lint/spec'

describe ROM::FMP::Repository do
  let(:result){[Rfm::Layout.new('layout_one', DB_CONFIG), Rfm::Layout.new('layout_two', DB_CONFIG)]}
  before do
    allow(result).to receive(:all).and_return(result)
    allow(result).to receive(:names).and_return(result)
    allow_any_instance_of(Rfm::Database).to receive(:layouts).and_return(result)
  end
  it_behaves_like 'a rom repository' do
    let(:identifier) { :fmp }
    let(:repository) { ROM::FMP::Repository }
    let(:uri) { DB_CONFIG }
  end
end
