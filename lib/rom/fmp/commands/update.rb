require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Update < ROM::Commands::Update
        include InstanceMethods
        
        adapter :fmp
        
        def execute(attributes)
        
          # Returns an instance of ROM::Relation::Loaded with:
          # source: a dataset containing all fmp resultsets from the operation.
          # collection: a dataset containing resultset records from the operation.
          # The result of this does not respond to :as. Use the >> method for piping results to a mapper.
          new_dataset = Dataset.new([]).concat(map{|tuple| callable_relation.dataset.update(tuple['record_id'], attributes).data})
          ROM::Relation::Loaded.new(new_dataset, new_dataset.map{|resultset| resultset.to_a}.flatten(1).to_a)
        
          # Original scheme: returns array. Uses old callable_relation. Processing done in command (here).
          #
          # puts "Update#execute SELF:"
          # puts self.inspect
          # puts "Update#execute RELATION:"
          # puts relation.inspect rescue $!
          # puts "Update#execute RELATION SOURCE:"
          # puts relation.source.inspect rescue $!
          # puts "Update#execute SOURCE:"
          # puts source.inspect rescue $!
          #relation.map {|tuple| callable_relation.update(tuple['record_id'], attributes) }
          
          # Newest scheme: returns loaded relation. Uses newer callable_realtion. Processing done in relation.
          #callable_relation.update(attributes)
          
          # Newer (middle) scheme. Returns source relation with loaded dataset. Uses newer callable_relation. Processing done in command.
          # relation.inject(Dataset.new([])) do |initial, tuple|
          #   new_relation = callable_relation.update(tuple['record_id'], attributes)
          #   new_dataset = new_relation.dataset
          #   new_queries = new_dataset.queries
          #   initial_dataset = initial.respond_to?(:dataset) ? initial.dataset : initial
          #   initial_queries = initial_dataset.respond_to?(:queries) ? initial_dataset.queries : []
          #   puts "NEW_DATASET #{new_dataset}"
          #   puts "NEW_QUERIES #{new_queries}"
          #   puts "INITIAL_DATASET #{initial_dataset}"
          #   puts "INITIAL_QUERIES #{initial_queries}"
          #   
          #   new_dataset.data.concat initial_dataset.data
          #   new_queries.concat initial_queries
          #   new_relation
          # end
        end
        
      end
    end
  end
end
