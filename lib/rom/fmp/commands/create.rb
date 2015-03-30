require 'rom/fmp/commands'
#require 'rom/fmp/commands/transaction'

module ROM
  module FMP
    module Commands
      class Create < ROM::Commands::Create
        #include Transaction

        def execute(tuples)
          insert_tuples = Array([tuples]).flatten.map do |tuple|
            attributes = input[tuple]
            validator.call(attributes)
            attributes.to_h
          end

          insert(insert_tuples)
        rescue *ERRORS => e
          raise ConstraintError, e.message
        end

        def insert(tuples)
          pks = tuples.map { |tuple| relation.insert(tuple) }
          relation.where(relation.primary_key => pks)
        end
      end
    end
  end
end
