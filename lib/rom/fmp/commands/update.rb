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
          puts "Update#execute SELF:"
          puts self.inspect
          puts "Update#execute RELATION:"
          puts relation.inspect rescue $!
          puts "Update#execute RELATION SOURCE:"
          puts relation.source.inspect rescue $!
          puts "Update#execute SOURCE:"
          puts source.inspect rescue $!
          puts "Update#execute SOURCE RELATION:"
          puts source.relation.inspect rescue $!
          relation.each do |tuple|
            new_collection << case
              when source.respond_to?(:update); source.update(tuple['record_id'], attributes).one
              when relation.source.respond_to?(:update); relation.source.update(tuple['record_id'], attributes).one
              when relation.respond_to?(:update); relation.update(tuple['record_id'], attributes).one
            end
          end
          relation.collection.replace(new_collection)
          relation
        end
        
      end
    end
  end
end
