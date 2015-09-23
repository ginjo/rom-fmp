require 'rom/support/array_dataset'
require 'rom'
require 'rfm'
require 'rom/fmp/rfm/layout'
require 'charlatan'

module ROM
  module FMP
    
    class Dataset
      # This was used but is not now.
      #include ArrayDataset
      
      # TODO: Find out why datasets never have @data or @loaded.
      # Is @loaded even a ROM attribute? Or is it just my own creation? Answer: @loaded is part of the rfm layout or database object.
      
      # Used to compile compound queries from chained relations.
      extend ::Rfm::Scope
      
      DEFAULT_REQUEST_OPTIONS = {}
      
      # Dataset instance expects to hold Array of data in @data,
      # but it will also hold a FM Layout instance.
      # If any call to Dataset instance returns Array instance,
      # it will be wrapped in a new Dataset instance.
      include Charlatan.new(:data, kind: Array)
      attr_reader :layout, :data, :queries
      
      # Is now in Rfm::Scope      
      # def self.delineate_query(*request)
      #   options = (request.last.is_a?(Hash) && request.size > 1) ? request.pop : {}
      #   query = request.pop || {}
      #   action = request.pop || (query.size==0 ? :all : :find)
      #   [action, query, options]
      # end

      # Mixes chained queries together into single query.
      # Now works with multiple-request queries (using new rfm scope feature).
      # NOTE: Each query must be an array representing a full rfm request.
      # Other ways: consider mixing multi-request queries with intersection: (result1 & result2),
      # or with the new scope feature: query1(scope:query2(scope:query3))
      def self.compile_query(queries)
        puts "DATASET COMPILE QUERIES input:#{queries}"
        
        # Old way: works but doesn't handle fmp compound queries.
        #query.each_with_object([{},{}]){|x,o| o[0].merge!(x[0] || {}); o[1].merge!(x[1] || {})}
        
        # New way: handles compound queries. Reqires ginjo-rfm 3.0.11.
        return unless queries  # This should help introspecting dataset that results from record deletion. TODO: test this.
        rslt = queries.inject {|new_query,scope| apply_scope(new_query, scope)} ##puts "SCOPE INJECTION scope:#{scope} new_query:#{new_query}"; 
        puts "DATASET COMPILE QUERIES output:#{rslt}"
        rslt
      end      
      

      # Store layout, data, query in new dataset.
      # Why data & queries? ROM doesn't appear to be using those,
      # yet the linter insists on them.
      def initialize(_layout, _data=[], _queries=[])
        # puts "DATASET NEW LAYOUT #{_layout}"
        # puts "DATASET NEW DATA #{_data}"
        # puts "DATASET NEW QUERIES #{_queries}"
        @layout = _layout
        @queries = _queries
        # Linter insists on this too.
        super(_data)
      end
      
      
      
      # Creates new dataset with existing data & queries, plus new query
      def find(*args)
        #self.class.new(layout, data, (queries.dup << args))
        wrap_data(data, (queries.dup << args))
      end
      
      def any(options={})
        wrap_data(layout.any(options))
      end
      
      def all(options={})
        wrap_data(layout.all(DEFAULT_REQUEST_OPTIONS.merge(options)))
      end
      
      def count(*args)
        compiled_query = self.class.compile_query(queries)
        compiled_query ? layout.count(*compiled_query) : layout.total_count
      end
      
      def create(attributes={})
        puts "Would create #{layout.name} with #{attributes}, but instead will just find\n"
        #get_results(:create, [attributes])
        get_results(:any, {})
      end

      def update(*args)
        attributes = args.last.is_a?(Hash) ? args.pop : {}
        record_id = args[0] || [:id, :record_id, 'id', 'record_id'].find {|x| attributes.delete(x)}
        puts "Would update #{record_id} with #{attributes}, but instead will just find\n"
        #get_results(:edit, [record_id, attributes])
        get_results(:find, record_id)
      end

      def delete(record_id)
        puts "Would delete #{record_id}, but instead will just find\n"
        #get_results(:delete, record_id)
        get_results(:find, record_id)
      end      



      # Triggers actual fm action.
      def to_a
        (data.nil? || data.empty?) ? call.data.to_a : data.to_a
      end
      
      # Triggers actual fm action.
      def each
        # passes block - if any - to upstream each.
        to_a.each(&Proc.new)
      end
      
      # Combines all queries, sends to FM, returns result in new dataset.
      def call
        compiled_query = self.class.compile_query(queries)
        wrap_data(compiled_query ? layout.find(*compiled_query) : layout.all(DEFAULT_REQUEST_OPTIONS))
      end
            
      # Returns new dataset containing data, layout, query.
      def wrap_data(_data=data, _queries=queries, _layout=layout)
        self.class.new(_layout, _data, _queries)
      end
      
      # Send method & query to layout, and wrap results in new dataset.
      def get_results(_method, query=queries, _layout=layout)
        puts "Dataset#get_results method: #{_method}, query: #{query}, layout: #{layout}"
        
        # This works just as well as the next one.
        #wrap_data(_layout.send(_method, *query), query, _layout)
        
        # This doesn't seem to add anything (even data!) to the objects operated on or created.
        @data = _layout.send(_method, *query)
        wrap_data(@data, query, _layout)
      end

    end # Dataset
  end # FMP
end # ROM
