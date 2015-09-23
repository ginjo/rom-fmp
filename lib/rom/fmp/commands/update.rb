require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Update < ROM::Commands::Update
        include InstanceMethods
        
        adapter :fmp
        
        def execute(attributes)
          # puts "Update#execute SELF:"
          # puts self.inspect
          # puts "Update#execute RELATION:"
          # puts relation.inspect rescue $!
          # puts "Update#execute RELATION SOURCE:"
          # puts relation.source.inspect rescue $!
          # puts "Update#execute SOURCE:"
          # puts source.inspect rescue $!
          relation.map {|tuple| callable_relation.update(tuple['record_id'], attributes).one }
        end
        
      end
    end
  end
end
