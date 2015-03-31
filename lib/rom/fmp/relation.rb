require 'rom/fmp/header'

#require 'rom/fmp/relation/class_methods'
#require 'rom/fmp/relation/inspection'
#require 'rom/fmp/relation/associations'

module ROM
  module FMP
    # Sequel-specific relation extensions
    #
    class Relation < ROM::Relation
      extend ClassMethods

      attr_reader :header, :table

      # @api private
      def initialize(dataset, registry = {})
        super
        #@table = dataset.opts[:from].first
        @table = dataset
      end

      # Return a header for this relation
      #
      # @return [Header]
      #
      # @api private
      def header
        #@header ||= Header.new(dataset.opts[:select] || dataset.columns, table)
        @header ||= Header.new(dataset.field_names, table)
      end

      # Return raw column names
      #
      # @return [Array<Symbol>]
      #
      # @api private
      def columns
        #dataset.columns
        dataset.field_names
      end

      # Get first tuple from the relation
      #
      # @example
      #   users.first
      #
      # @return [Relation]
      #
      # @api public
      def first
        #dataset.first
        dataset.all :max_records=>1
      end

      # Get last tuple from the relation
      #
      # @example
      #   users.first
      #
      # @return [Relation]
      #
      # @api public
      def last
        total = dataset.total_count
        dataset.all(:max_records => 1, :skip_records => total-1)
      end
      
      def find(*args, &block)
        __new__(dataset.__send__(__method__, *args, &block))
      end
      
      def all(*args, &block)
        __new__(dataset.__send__(__method__, *args, &block))
      end
      
      def any(*args, &block)
        __new__(dataset.__send__(__method__, *args, &block))
      end
      
      def count(*args, &block)
        __new__(dataset.__send__(__method__, *args, &block))
      end

      # Restrict a relation to not match criteria
      #
      # @example
      #   users.exclude(name: 'Jane')
      #
      # @return [Relation]
      #
      # @api public
      def exclude(*args, &block)
        # __new__(dataset.__send__(__method__, *args, &block))
        args[:omit] = true if args[0].kind_of?(Hash)
        __new__(dataset.__send__(:find, *args, &block))
      end

      # # Set order for the relation
      # #
      # # @example
      # #   users.order(:name)
      # #
      # # @return [Relation]
      # #
      # # @api public
      # def order(*args, &block)
      #   # __new__(dataset.__send__(__method__, *args, &block))
      #   args[:sort_field] = :some_field
      #   __new__(dataset.__send__(:find, *args, &block))
      # end

      # # Reverse the order of the relation
      # #
      # # @example
      # #   users.order(:name).reverse
      # #
      # # @return [Relation]
      # #
      # # @api public
      # def reverse(*args, &block)
      #   __new__(dataset.__send__(__method__, *args, &block))
      # end

      # # Limit a relation to a specific number of tuples
      # #
      # # @example
      # #   users.limit(1)
      # #
      # # @return [Relation]
      # #
      # # @api public
      # def limit(*args, &block)
      #   __new__(dataset.__send__(__method__, *args, &block))
      # end

      # # Set offset for the relation
      # #
      # # @example
      # #   users.limit(10).offset(2)
      # #
      # # @return [Relation]
      # #
      # # @api public
      # def offset(*args, &block)
      #   __new__(dataset.__send__(__method__, *args, &block))
      # end

      # Map tuples from the relation
      #
      # @example
      #   users.map { |user| ... }
      #
      # @api public
      def map(&block)
        to_enum.map(&block)
      end

      forward :find, :all, :any, :count


    end
  end
end
