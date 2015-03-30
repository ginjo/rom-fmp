require "rom/fmp/version"
require 'rfm'
require 'rom'

module ROM
  module FMP
    ConstraintError = Class.new(ROM::CommandError)
  end
end
