require 'rom/fmp/commands'
require 'rom/fmp/commands/transaction'

module ROM
  module SQL
    module Commands
      class Delete < ROM::Commands::Delete
        include Transaction

        def execute
          deleted = target.to_a
          target.delete
          deleted
        end
      end
    end
  end
end
