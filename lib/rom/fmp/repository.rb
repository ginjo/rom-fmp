require 'logger'
require 'rom/repository'
require 'rom/fmp/commands'
require 'rfm'
require 'yaml'

require 'rom/fmp/dataset'

module ROM
  module FMP
    class Repository < ROM::Gateway
    	#FMRESULTSET_TEMPLATE = {:template=>YAML.load_file(File.expand_path("../rfm/fmresultset.yml", __FILE__))}
    	
      # WBR
      attr_reader :resources
      
      # Return optionally configured logger
      #
      # @return [Object] logger
      #
      # @api public
      attr_reader :logger

      # Filemaker repository interface
      #
      # @overload connect(uri, options)
      #   Connects to database via uri passing options
      #
      #   @param [String,Symbol] uri connection URI
      #   @param [Hash] options connection options
      #
      # @overload connect(connection)
      #   Re-uses connection instance
      #
      #   @param [Rfm::Database] connection a connection instance
      #
      # @example
      #   repository = ROM::FMP::Gateway.new(DB_CONFIG)
      #
      #   # or reuse connection
      #   DB = Rfm::Database.new(DB_CONFIG)
      #   repository = ROM::FMP::Gateway.new(DB)
      #
      # @api public
      def initialize(uri, options = {})
        #y [uri, options]
        @connection = connect(uri, options)
        @resources = {}
        @schema = []
      end
      
      # WBR
      
	    def [](name)
	    	#puts "REPOSITORY#[]: #{name}"
	      resources.fetch(name)
	    end
	
	    def dataset(name)
	    	#puts "REPOSITORY#dataset: #{name}"
	    	
	    	# Fancy version
	      #resources[name] = Dataset.build(connection[name.to_s])
	      
	      # Bare-bones version
	      #resources[name] = connection[name]
	      
	      # Influxdb version
	      #resources[name] = Dataset.new(name, connection)
	      
	    	# Enlightened version
	      resources[name] = Dataset.new(connection[name.to_s])
	    end
	
	    def dataset?(name)
	      resources.key?(name)
	    end
      
      # Setup a logger
      #
      # @param [Object] logger
      #
      # @api public
      def use_logger(logger)
        @logger = logger
        #connection.loggers << logger
        connection.config :logger => logger
      end      
      
      
      
			#       # Returns a list of datasets inferred from table names
			#       #
			#       # @return [Array] array with table names
			#       #
			#       # @api public
			#       attr_reader :schema   
			#   			      
			#       # List available table names in repository, represented by filemaker table-occurrences.
			#       #
			#       # @return [Rfm::Layout] 
			#       def schema
			# 	      # original:	connection.layouts.all.names.find_all {|n| n.to_s[/_xml$/i]}
			# 	      @schema ||= connection.layouts.names.find_all {|n| n.to_s[/_xml$/i]}
			# 	    end
			#
			#       # Check if dataset exists
			#       #
			#       # @param [String] name dataset name
			#       #
			#       # @api public
			#       def dataset?(name)
			#         schema.include?(name)
			#       end

      private

      # Connect to database or reuse established connection instance
      #
      # @return [Rfm::Database] a connection instance
      #
      # @api private
      #def connect(uri, *args)
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

