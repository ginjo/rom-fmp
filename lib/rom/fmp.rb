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
#require "rom/fmp/migration"

# From rom-sql
# if defined?(Rails)
#   require "rom/sql/support/active_support_notifications"
#   require 'rom/sql/support/rails_log_subscriber'
# end

ROM.register_adapter(:fmp, ROM::FMP)
