require 'rfm'
require 'rom'
require 'yaml'

module ROM
  module FMP
    ConstraintError = Class.new(ROM::CommandError)
    FMRESULTSET_TEMPLATE = {:template=>YAML.load_file(File.expand_path("../fmp/rfm/fmresultset.yml", __FILE__))}
  end
end

require "rom/fmp/version"
require "rom/fmp/dataset"
require "rom/fmp/gateway"
require "rom/fmp/commands"
require "rom/fmp/relation"
require "rom/fmp/rfm/layout"
#require "rom/fmp/rfm/resultset"

#require "rom/fmp/mini"
#require "rom/fmp/micro01"
#require "rom/fmp/micro02"

ROM.register_adapter(:fmp, ROM::FMP)
