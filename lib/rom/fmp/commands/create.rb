require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Create < ROM::Commands::Create
        include InstanceMethods
        
        adapter :fmp

        def execute(*tuples)
          tuples.flatten(1).map { |tuple| callable_relation.create(tuple).one }
        end

      end
    end
  end
end
