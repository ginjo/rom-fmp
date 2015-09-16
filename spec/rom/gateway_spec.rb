require 'spec_helper'

require 'rom/lint/spec'

# These pass!
describe ROM::FMP::Gateway do
  let(:result){[Rfm::Layout.new('layout_one', DB_CONFIG), Rfm::Layout.new('layout_two', DB_CONFIG)]}
  before do
    allow(result).to receive(:all).and_return(result)
    allow(result).to receive(:names).and_return(result)
    allow_any_instance_of(Rfm::Database).to receive(:layouts).and_return(result)
  end
  
  it_behaves_like 'a rom gateway' do
    let(:identifier) { :fmp }
    let(:gateway) { ROM::FMP::Gateway }
    let(:uri) { DB_CONFIG }
  end
end

# This is really for Dataset, which doesn't exist for rom-fmp as a distinct class yet.
# Taken from https://github.com/rom-rb/rom/blob/master/spec/unit/rom/memory/dataset_spec.rb
# These don't pass (yet).
describe 'ROM::FMP::Gateway#dataset' do
  let(:layouts){[Rfm::Layout.new('layout_one', DB_CONFIG), Rfm::Layout.new('layout_two', DB_CONFIG)]}
  before do
    allow(layouts).to receive(:all).and_return(layouts)
    allow(layouts).to receive(:names).and_return(layouts.map {|r| r.name})
    allow(layouts[0]).to receive(:find).and_return(data)
    allow_any_instance_of(Rfm::Database).to receive(:layouts).and_return(layouts)
  end

  # Use this when a ROM::FMP::Dataset class doesn't exist yet.
  #subject(:dataset)  { Rfm::Layout.new('layout_one', DB_CONFIG) }     #{ described_class.new(data) }
  
  # Use this after you develop a ROM::FMP::Dataset class
  subject(:dataset)  { ROM::FMP::Dataset.new(layouts[0]) }     #{ described_class.new(data) }
  
  before do
  	allow_any_instance_of(Rfm::Layout).to receive(:get_records).and_return(data)
  end

  let(:data) do
    [
      { name: 'Jane', email: 'jane@doe.org', age: 10 },
      { name: 'Jade', email: 'jade@doe.org', age: 11 },
      { name: 'Joe', email: 'joe@doe.org', age: 12 }
    ]
  end

  it_behaves_like "a rom enumerable dataset"

end
