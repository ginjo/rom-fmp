require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Delete < ROM::Commands::Delete
        include InstanceMethods
        
        adapter :fmp

        def execute   
          # TODO: make this like Update, so returns updated data,
          # and works with loaded relations.       
          relation.map { |tuple| callable_relation.delete(tuple['record_id']).one }
        end
        
      end
    end
  end
end
