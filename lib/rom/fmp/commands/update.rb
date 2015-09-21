require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Update < ROM::Commands::Update
        adapter :fmp

        def execute(*args)
          attributes = args.last.is_a?(Hash) ? args.pop : {}
          record_id = args[0] || [:id, :record_id, 'id', 'record_id'].find {|x| attributes.delete(x)}
          
          if record_id
            source.update(record_id, attributes)
          else
            relation.each { |tuple| source.update(tuple['record_id'], attributes) }
          end
        end
        
      end
    end
  end
end
