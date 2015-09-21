#require 'rom/support/array_dataset'
require 'rom'
require 'rfm'
require 'rom/fmp/rfm/layout'
require 'charlatan'

module ROM
  module FMP
    
    class Dataset
      # This was used but is not now.
      # include Rom::ArrayDataset
      
      # Used to compile compound queries from chained relations.
      include ::Rfm::Scope
      
      DEFAULT_REQUEST_OPTIONS = {}
      
      # Dataset instance expects to hold Array of data in @data,
      # but it will also hold a FM Layout instance.
      # If any call to Dataset instance returns Array instance,
      # it will be wrapped in a new Dataset instance.
      include Charlatan.new(:data, kind: Array)
      attr_reader :layout, :data, :queries

      # Store layout, data, query in new dataset.
      def initialize(_layout, _data=[], _queries=[])
        @layout = _layout
        @queries = _queries
        #puts "DATASET NEW queries:#{@queries}"
        super(_data)
      end
      
      
      
      # Creates new dataset with current args and resultset. Not lazy.
      # This may not be how rom or sql uses 'where'. Find out more.
      def where(*args)
        #self.class.new(layout, layout.find(*args), args)
        get_results(:find, args)
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
        compiled_query = compile_query
        compiled_query ? layout.count(*compiled_query) : layout.total_count
      end
      
      def create(attributes={})
        puts "Would create #{record_id} with #{attributes}, but instead will just find\n"
        #get_results(:create, [attributes])
        get_results(:any)
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
        compiled_query = compile_query
        wrap_data(compiled_query ? layout.find(*compiled_query) : layout.all(DEFAULT_REQUEST_OPTIONS))
      end
      
      # Mixes chained queries together into single query.
      # Now works with multiple-request queries (using new rfm scope feature).
      # Other ways: consider mixing multi-request queries with intersection: (result1 & result2),
      # or with the new scope feature: query1(scope:query2(scope:query3))
      def compile_query
        #puts "DATASET COMPILE self #{self}"
        #puts "DATASET COMPILE queries #{queries}"
        
        # Old way: works but doesn't handle fmp compound queries.
        #query.each_with_object([{},{}]){|x,o| o[0].merge!(x[0] || {}); o[1].merge!(x[1] || {})}
        
        # New way: handles compound queries. Reqires ginjo-rfm 3.0.11.
        return unless queries  # This should help introspecting dataset that results from record deletion. TODO: test this.
        queries.inject {|new_query,scope| apply_scope(new_query, scope)} ##puts "SCOPE INJECTION scope:#{scope} new_query:#{new_query}"; 
      end
            
      # Returns new dataset containing, data, layout, query.
      def wrap_data(_data=data, _queries=queries, _layout=layout)
        self.class.new(_layout, _data, _queries)
      end
      
      # Send method & query to layout, and wrap results in new dataset.
      def get_results(_method, query=queries, _layout=layout)
        wrap_data(_layout.send(_method, *query), query, _layout)
      end

    end # Dataset
  end # FMP
end # ROM
