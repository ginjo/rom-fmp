require 'rom/commands'

module ROM
  module SQL
    module Commands
      ERRORS = [
        Sequel::UniqueConstraintViolation,
        Sequel::NotNullConstraintViolation
      ].freeze
    end
  end
end

require 'rom/fmp/commands/create'
require 'rom/fmp/commands/update'
require 'rom/fmp/commands/delete'
require 'rom/fmp/commands_ext/postgres'
