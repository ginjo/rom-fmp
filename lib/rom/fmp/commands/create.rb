require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Create < ROM::Commands::Create
        adapter :fmp

        def execute(*tuples)
          # TODO: make this like Update, so returns updated data,
          # and works with loaded relations.
          tuples.flatten(1).each { |tuple| relation.create(tuple) }
        end

      end
    end
  end
end
