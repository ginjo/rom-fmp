
module ROM
  module FMP
    module Commands
      module InstanceMethods
      
        # Return the nearest callable relation from within command,
        # so can be used for create, update, delete, when calling these commands on loaded relations.
        # These should be in the following order to work with chained relations & commands:
        #   source, relation.source, relation
        def callable_relation
          #puts "CALLABLE_RELATION"
          case
            when source.respond_to?(:call);
              #puts "source:#{source.inspect}"
              source
            when (relation.source.respond_to?(:call) rescue nil);
              #puts  "relation.source:#{relation.source.inspect}"
              relation.source
            when relation.respond_to?(:call);
              #puts "relation:#{relation.inspect}"
              relation
          end
        end
        
      end
    end
  end
end