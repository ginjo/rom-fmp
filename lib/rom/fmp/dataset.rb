require 'rom/support/array_dataset'
require 'rom'
require 'rfm'
require 'rom/fmp/rfm/layout'
require 'charlatan'

module ROM
  module FMP
    
    class Dataset
      FMPID = 'fmp_record_id'
      # This was used but is not now.
      #include ArrayDataset
      
      # TODO: Find out why datasets never have @data or @loaded.
      # Is @loaded even a ROM attribute? Or is it just my own creation? Answer: @loaded is part of the rfm layout or database object.
      
      # Used to compile compound queries from chained relations.
      extend ::Rfm::Scope
      
      DEFAULT_REQUEST_OPTIONS = {}
      
      # Calls to dataset that get forwarded, and return
      # the same class type as @data, or are of kind Array,
      # will be automatically wrapped in Dataset.
      # NOTE: @data can be either a layout or a resultset.
      include Charlatan.new(:data, kind: Array)
      attr_reader :queries
      alias_method :layout, :data



      # Mixes chained queries together into single query.
      # Now works with multiple-request queries (using new rfm scope feature).
      # NOTE: Each query must be an array representing a full rfm request.
      # Other ways: consider mixing multi-request queries with intersection: (result1 & result2),
      # or with the new scope feature: query1(scope:query2(scope:query3))
      def self.compile_query(queries)
        #puts "DATASET COMPILE QUERIES input:#{queries}"
        
        # Old way: works but doesn't handle fmp compound queries.
        #query.each_with_object([{},{}]){|x,o| o[0].merge!(x[0] || {}); o[1].merge!(x[1] || {})}
        
        # New way: handles compound queries. Reqires ginjo-rfm 3.0.11.
        return [] unless queries.any?  # This should help introspecting dataset that results from record deletion. TODO: test this.
        rslt = queries.inject {|new_query,scope| apply_scope(new_query, scope)}
        #puts "DATASET COMPILE QUERIES output:#{rslt}"
        #rslt
      end      
      


      # Store layout, data, query in new dataset.
      # Why data & queries? ROM doesn't appear to be using those,
      # yet the linter insists on them.
      def initialize(_layout, _queries=[])
        # puts "DATASET NEW LAYOUT #{_layout}"
        # puts "DATASET NEW QUERIES #{_queries}"
        @queries = [_queries].flatten(1)  # Flatten in case you pass in a string.
        # Super is necessary for Charlatan to work.
        super(_layout)
      end
      
      # Creates new dataset with existing data & queries, plus new query
      def find(*args)
        #self.class.new(layout, data, (queries.dup << args))
        wrap_data(data, (queries.dup << args))
      end
      
      def any(options={})
        wrap_data(layout.any(options))
      end
      
      def all(options)
        wrap_data(layout.all(DEFAULT_REQUEST_OPTIONS.merge(options)))
      end
      private :all
      
      # Performs a standard query but returns count of results instead of restulset.
      def count(*args)
        compiled_query = self.class.compile_query(queries)
        compiled_query.any? ? layout.count(*compiled_query) : layout.total_count
      end
      
      # Create one or more records from tuples.
      def create(*args)
        tuples = args.flatten
        tuples.collect do |tuple|
          #puts "Would create #{layout.name} with #{tuple}, but instead will just find\n"
          #get_results(:any, {}).first
          get_results(:create, [tuple]).first
        end
      end

      # Update one or more records given attributes and id-or-record list (any order!).
      def update(*args)
        attributes = case
        when args.last.is_a?(Hash); args.pop
        when args.first.is_a?(Hash); args.shift
        else raise("Dateset#update requires an attribute hash.")
        end
        
        args = args.flatten
        
        ids = case
        when args.empty?; attributes.delete(FMPID)
        else args.collect{|a| a.is_a?(Hash) ? a[FMPID] : a.to_s }
        end
        #puts "DATASET#update attributes: #{attributes}"
        #puts "DATASET#update ids: #{ids}"
        ids.collect do |id|
          #puts "Would update #{id} with #{attributes}, but instead will just find\n"
          #get_results(:find, id).first
          get_results(:edit, [id, attributes]).first
        end
      end

      # Delete one or more records given id-or-record list. 
      def delete(*args)
        ids = args.flatten.collect{|a| a.is_a?(Hash) ? a[FMPID] : a.to_s }
        ids.collect do |id|
          #puts "Would delete #{id}, but instead will just find\n"
          #get_results(:find, id)
          get_results(:delete, id).first
        end
      end      




      # Triggers actual fm action.
      def to_a
        (data.is_a?(::Rfm::Layout) || data.empty?) ? call.data.to_a : data.to_a
      end
      #alias_method :to_ary, :to_a
      
      # Triggers actual fm action.
      def each
        # passes block - if any - to upstream each.
        to_a.each(&Proc.new)
      end
      
      # Combines all queries, sends to FM, returns result in new dataset.
      def call
        compiled_query = self.class.compile_query(queries)
        wrap_data(compiled_query.any? ? layout.find(*compiled_query) : layout.all(DEFAULT_REQUEST_OPTIONS))
      end
      
      # Send method & query to layout, and wrap results in new dataset.
      def get_results(_method, query=queries, _layout=layout)
        #puts "Dataset#get_results self: #{self} method: #{_method}, query: #{query}, layout: #{layout}"
        
        # This works just as well as the next one.
        wrap_data(_layout.send(_method, *query), query)
        
        # Lingering @data might be causing problems with 2+n calls to commands.
        #@data = _layout.send(_method, *query)
        #wrap_data(@data, query, _layout)
      end
            
      # Returns new dataset containing data, layout, query.
      def wrap_data(_data=data, _queries=queries)
        self.class.new(_data, _queries)
      end
      
    end # Dataset
  end # FMP
end # ROM
