require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Create < ROM::Commands::Create
        adapter :fmp

        def execute(*tuples)
          tuples.flatten(1).each { |tuple| relation.create(tuple) }
          
        # This is from sql adapter
        rescue *ERRORS => e
          raise ConstraintError, e.message
        end

      end
    end
  end
end
