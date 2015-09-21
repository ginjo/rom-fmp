
module ROM
  module FMP
    module Commands
      module InstanceMethods
      
        # Return the nearest callable relation from within command,
        # so can be used for create, update, delete.
        def callable_relation
          case
            when source.respond_to?(:call); source
            when relation.respond_to?(:call); relation
            when relation.source.respond_to?(:call); relation.source
          end
        end
        
      end
    end
  end
end