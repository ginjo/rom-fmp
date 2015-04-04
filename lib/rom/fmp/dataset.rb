require 'charlatan'

# TODO: Same top-level dataset sticks around for unrelated calls. I don't think that is good.

module ROM
  module FMP
  
    class Resource
      include Enumerable

      #attr_reader :connection, :path
      attr_accessor :layout, :query

      def initialize(layout, query=[])  #query=[:all, :max_records=>10])
      	puts "RESOURCE<#{self.object_id}>#initialize with layout: #{layout.class} #{layout.name} #{layout.object_id}, query: #{query}"
        @layout = layout
        @query = query
      end

      def each(&block)
        #JSON.parse(connection.get(path).body).each(&block)
        layout.send(*query).each(&block)
      end
      
		  def find(*args)
		  	self.class.new(layout, [__method__, *args])
		  end
      
    end # Resource

    class Dataset
      include Charlatan.new(:data, kind: Enumerable)

      def self.build(*args)
        new(Resource.new(*args))
      end

			def initialize(*args)
				puts "DATASET<#{self.object_id}>#initialize with args: #{args.class} #{args.object_id}"
			  super
			end
    end # Dataset

  end # FMP
end # ROM

class Rfm::Layout
	def inspect
		"#<#{self.class.name}:#{self.object_id} @name=#{self.name} @database=#{database.name} @server=#{server.host_name} @loaded=#{@loaded}>"
	end

end
