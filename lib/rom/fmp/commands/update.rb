require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Update < ROM::Commands::Update
        include InstanceMethods
        
        adapter :fmp
        
        def execute(attributes)
          #new_collection=[]
          # puts "Update#execute SELF:"
          # puts self.inspect
          # puts "Update#execute RELATION:"
          # puts relation.inspect rescue $!
          # puts "Update#execute RELATION SOURCE:"
          # puts relation.source.inspect rescue $!
          # puts "Update#execute SOURCE:"
          # puts source.inspect rescue $!
          # puts "Update#execute SOURCE RELATION:"
          # puts source.relation.inspect rescue $!
          relation.map {|tuple| callable_relation.update(tuple['record_id'], attributes).one}.to_a
        end
        
      end
    end
  end
end
