require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Update < ROM::Commands::Update
        adapter :fmp

        def execute(attributes)
          # Replaces relation collection with updated records.
          # The 'relation.source.update' is to handle loaded relations.
          new_collection=[]
          relation.each { |tuple| new_collection << relation.source.update(tuple['record_id'], attributes).one }
          relation.collection.replace(new_collection)
          relation
        end
        
      end
    end
  end
end
