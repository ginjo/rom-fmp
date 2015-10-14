require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Delete < ROM::Commands::Delete
        include InstanceMethods
        
        adapter :fmp

        def execute  
          relation.map { |tuple| callable_relation.dataset.delete(tuple['record_id']).first }
        end
        
      end
    end
  end
end
