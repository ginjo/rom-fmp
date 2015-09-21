require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Delete < ROM::Commands::Delete
        adapter :fmp

        def execute(record_id=nil)          
          if record_id
            source.delete(record_id)
          else
            relation.each { |tuple| source.delete(tuple['record_id']) }
          end
        end
        
      end
    end
  end
end
