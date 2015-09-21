require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Delete < ROM::Commands::Delete
        adapter :fmp

        def execute   
          # TODO: make this like Update, so returns updated data,
          # and works with loaded relations.       
          relation.each { |tuple| source.delete(tuple['record_id']) }
        end
        
      end
    end
  end
end
