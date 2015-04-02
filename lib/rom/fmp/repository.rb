require 'logger'
require 'rom/repository'
require 'rom/fmp/commands'
require 'yaml'

require 'rom/fmp/dataset'

module ROM
  module FMP
    class Repository < ROM::Repository
    	FMRESULTSET_TEMPLATE = {:template=>YAML.load_file(File.expand_path("../rfm/dm-fmresultset.yml", __FILE__))}
      
      # Return optionally configured logger
      #
      # @return [Object] logger
      #
      # @api public
      attr_reader :logger

      # Returns a list of datasets inferred from table names
      #
      # @return [Array] array with table names
      #
      # @api public
      attr_reader :schema

      # # @param [String,Symbol] scheme
      # #
      # # @api public
      # def self.database_file?(scheme)
      #   scheme.to_s.include?('sqlite')
      # end

      # SQL repository interface
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
      #   @param [Sequel::Database] connection a connection instance
      #
      # @example
      #   repository = ROM::SQL::Repository.new('postgres://localhost/rom')
      #
      #   # or reuse connection
      #   DB = Sequel.connect('postgres://localhost/rom')
      #   repository = ROM::SQL::Repository.new(DB)
      #
      # @api public
      def initialize(uri, options = {})
        #y [uri, options]
        @connection = connect(uri, options)
        
      end
      
      # TODO: Specify Rfm::Database as a string in parser-template-yml-file
      
      # List available table names in repository, represented by filemaker table-occurrences.
      #
      # @return [Rfm::Layout] 
      def schema
	      # original:	connection.layouts.all.names.find_all {|n| n.to_s[/_xml$/i]}
	      @schema ||= connection.layouts.names.find_all {|n| n.to_s[/_xml$/i]}
	    end

      # # Disconnect from database
      # #
      # # @api public
      # def disconnect
      #   #connection.disconnect
      # end

      # Return dataset with the given name
      #
      # @param [String] name dataset name
      #
      # @return [Dataset]
      #
      # @api public
      def [](name)
        connection[name]
      end

      # Setup a logger
      #
      # @param [Object] logger
      #
      # @see Sequel::Database#loggers
      #
      # @api public
      def use_logger(logger)
        @logger = logger
        #connection.loggers << logger
        connection.config :logger => logger
      end

      # Return dataset with the given name
      #
      # @param [String] name a dataset name
      #
      # @return [Dataset]
      #
      # @api public
      def dataset(name)
        FMP::Dataset.new(connection[name]) #, [])
        #Dataset.build(connection[name], name.to_s, header)
      end

      # Check if dataset exists
      #
      # @param [String] name dataset name
      #
      # @api public
      def dataset?(name)
        schema.include?(name)
      end

      # # Extend database-specific behavior
      # #
      # # @param [Class] klass command class
      # # @param [Object] dataset a dataset that will be used
      # #
      # # Note: Currently, only postgres is supported.
      # #
      # # @api public
      # def extend_command_class(klass, dataset)
      #   #type = dataset.db.database_type
      #   type = :fmp
      # 
      #   if type == :postgres
      #     ext =
      #       if klass < Commands::Create
      #         Commands::Postgres::Create
      #       elsif klass < Commands::Update
      #         Commands::Postgres::Update
      #       end
      # 
      #     klass.send(:include, ext) if ext
      #   end
      # 
      #   klass
      # end

      private

      # Connect to database or reuse established connection instance
      #
      # @return [Database::Sequel] a connection instance
      #
      # @api private
      #def connect(uri, *args)
      def connect(*args)
        options = args.last.kind_of?(Hash) ? args.pop : Hash.new
        options.merge! args.pop if args.last.kind_of?(Hash)
        case args[0]
        when ::Rfm::Database
          args[0]
        else
          #::Rfm::Database.new(uri[:database], *Array([uri.to_s, *args]).flatten)
          #Rfm.layout(storage_name, repository.adapter.options.merge(FMRESULTSET_TEMPLATE).symbolize_keys)
          ::Rfm.database(*args, options.to_h.merge(FMRESULTSET_TEMPLATE).to_h)
        end
      end
      
    end # Repository
  end # FMP
end # ROM

