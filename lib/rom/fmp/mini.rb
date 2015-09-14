# This is an alternative version of rom-fmp, with all moduels & classes in a single file.

require 'logger'
require 'rom/repository'
require 'rom/fmp/commands'
require 'rfm'
require 'yaml'


module ROM
  module FMP
    class Relation < ROM::Relation
      forward :find, :where, :all, :any, :count
    end

    class Dataset
      include Equalizer.new(:name, :connection)

      attr_reader :name, :connection

      def initialize(name, connection)
        @name = name
        @connection = connection
      end

	    def find(*args)
	    	table.find(*args)
	    end
	
	    def each(&block)
	      table.all(:max_records=>10).each(&block)
	    end	    
	    
			def to_a
				table.all(:max_records=>10)
			end
			
			private
			
			def table
				@table ||= connection[name]
			end
    end

    class Repository < ROM::Repository
      attr_reader :sets

      def initialize(uri, options = {})
        #y [uri, options]
        @connection = connect(uri, options)
        @sets = {}
      end

      def dataset(name)
        sets[name] = Dataset.new(name, connection)
      end

      def [](name)
        sets.fetch(name)
      end

      def dataset?(name)
        sets.key?(name)
      end
      
      def connect(*args)
        options = args.last.kind_of?(Hash) ? args.pop : Hash.new
        options.merge! args.pop if args.last.kind_of?(Hash)
        case args[0]
        when Rfm::Database
          args[0]
        else
          #::Rfm::Database.new(uri[:database], *Array([uri.to_s, *args]).flatten)
          #Rfm.layout(storage_name, repository.adapter.options.merge(FMRESULTSET_TEMPLATE).symbolize_keys)
          Rfm.database(*args, options.to_h.merge(FMRESULTSET_TEMPLATE).to_h)
        end
      end
      
    end # Repository
  end # FMP
end # ROM
