# This is an alternative version of rom-fmp, with all moduels & classes in a single file.

require 'logger'
require 'rom/gateway'
require 'rfm'
require 'charlatan'
require 'yaml'

class Rfm::Layout
  
  # include Charlatan.new(:data, kind: Array)
  # 
  # attr_reader :layout, :data, :query
  # def initialize(layout, data=[], query=[])
  #   @layout = layout
  #   @query = query
  #   super(data)
  # end

  # def to_a
  #   all(:max_records=>10)
  # end
  # 
  # def each
  #   to_a.each(&Proc.new)
  # end
  
  # Strip out unnecessary output in Rfm::Layout#inspect
  def inspect
    "#<#{self.class.name}:#{self.object_id} @name=#{self.name} @database=#{database.name} @server=#{server.host_name} @loaded=#{@loaded}>"
  end
end

module ROM
  module FMP
  
  
    class Gateway < ROM::Gateway
      attr_reader :datasets, :database
      
      def initialize(*options)
        @database = Rfm.database(options[0].to_h.merge(FMRESULTSET_TEMPLATE).to_h)
        @datasets = Hash.new
      end
      
      def dataset(name)
        datasets[name.to_s] ||= Dataset.new(@database[name.to_s])
      end
      
      # This is required per lint specs
      alias_method :[], :dataset
      
      def dataset?(name)
        datasets.key?(name.to_s)
      end
    end
    
    
    class Dataset
      
      # Dataset instance expects to hold Array of data in @data,
      # but it will also hold a FM Layout instance.
      # If any call to Dataset instance returns Array instance,
      # it will be wrapped in a new Dataset instance.
      include Charlatan.new(:data, kind: Array)
      attr_reader :layout, :data, :query

      # Store layout, data, query in new dataset.
      def initialize(layout, data=[], query=[])
        @layout = layout
        @query = query
        super(data)
      end
      
      # Creates new dataset with current args and resultset. Not lazy.
      # This may not be how rom or sql uses 'where'. Find out more.
      def where(*args)
        self.class.new(layout, layout.find(*args), args)
      end
      
      # Creates new dataset with existing data & query, plus new query
      def find(*args)
        self.class.new(layout, data, (query.dup << args))
      end
      
      # Combines all queries, sends to FM, returns result in new dataset.
      def call
        compiled_query = compile
        self.class.new(
          layout,
          compiled_query[0].empty? ? layout.all(:max_records=>10) : layout.find(*compile),
          query
        )
      end
      
      # Mixes chained queries together into single query.
      # Doesn't work with multiple-request queries.
      # Consider mixing multi-request queries with intersection: (result1 & result2),
      # or with the new scope feature: query1(scope:query2(scope:query3))
      def compile
        query.each_with_object([{},{}]){|x,o| o[0].merge!(x[0] || {}); o[1].merge!(x[1] || {})}
      end
      
      # Triggers actual fm query.
      def to_a
        data.empty? ? call.data.to_a : data.to_a
      end
      
      # Triggers actual fm query.
      def each
        to_a.each(&Proc.new)
      end
      
      
      # #private
    
      # Don't expose Dataset#any
      def any(options={})
        self.class.new(layout, layout.any(options))
      end
      
      

    end # Dataset
  
  
    class Relation < ROM::Relation
      # we must configure adapter identifier here
      adapter :fmp

      forward :find, :all, :create, :edit, :delete
    end

    



  end # FMP
end # ROM
