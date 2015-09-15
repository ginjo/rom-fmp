require 'rfm'
require 'rom'
require 'yaml'

module ROM
  module FMP
    ConstraintError = Class.new(ROM::CommandError)
    FMRESULTSET_TEMPLATE = {:template=>YAML.load_file(File.expand_path("../fmp/rfm/fmresultset.yml", __FILE__))}
  end
end

# require "rom/fmp/version"
# require "rom/fmp/relation"
# require "rom/fmp/gateway"
#require "rom/fmp/mini"
require "rom/fmp/micro"

ROM.register_adapter(:fmp, ROM::FMP)
