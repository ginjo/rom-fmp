require 'rfm'
require 'rom'

module ROM
  module FMP
    ConstraintError = Class.new(ROM::CommandError)
  end
end

require "rom/fmp/version"
require "rom/fmp/relation"
require "rom/fmp/repository"

ROM.register_adapter(:fmp, ROM::FMP)
