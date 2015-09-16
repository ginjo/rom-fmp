# This is an alternative version of rom-fmp, with all moduels & classes in a single file.

require 'logger'
require 'rom/gateway'
require 'rom/fmp/commands'
require 'rfm'
require 'yaml'


module ROM
  module FMP
  
    class Relation < ROM::Relation
      adapter :fmp
      forward :find, :where, :all, :any, :count
    end
    

    class Gateway < ROM::Gateway
      attr_reader :sets

      def initialize(uri, options = {})
        puts "INITIALIZING GATEWAY WITH uri: #{uri} options: #{options}"
        @connection = connect(uri, options)
        @sets = {}
        self
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
          #Rfm.layout(storage_name, gateway.adapter.options.merge(FMRESULTSET_TEMPLATE).symbolize_keys)
          Rfm.database(*args, options.to_h.merge(FMRESULTSET_TEMPLATE).to_h)
        end
      end
      
    end # Gateway


    class Dataset
      #include Equalizer.new(:name, :connection)

      attr_reader :name, :connection, :table

      def initialize(name, connection)
        puts "INITIALIZING DATASET WITH name: #{name} connection: #{connection}"
        @name = name
        @connection = connection
        @table = connection[name.to_s]
        self
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
      
      # def table
      #   @table ||= connection[name]
      # end
      
    end # Dataset

  end # FMP
end # ROM
