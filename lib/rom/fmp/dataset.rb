require 'rom/support/array_dataset'
require 'charlatan'

class Rfm::Layout
	#include ROM::ArrayDataset

	# Strip out unnecessary output in Rfm::Layout#inspect
	def inspect
		"#<#{self.class.name}:#{self.object_id} @name=#{self.name} @database=#{database.name} @server=#{server.host_name} @loaded=#{@loaded}>"
	end
	
	# These are for bare-bones layout-is-dataset experiment
	def to_a
		all(:max_records=>10)
	end
	
	def each(&block)
		all(:max_records=>10).each(&block)
	end
end


# None of this is used in bare-bones layout-is-dataset experiment
module ROM
  module FMP
  
    class Resource
      include Enumerable

      #attr_reader :connection, :path
      attr_accessor :layout, :query

      def initialize(layout, query=[:all, :max_records=>10])  #query=[:all, :max_records=>10])
      	#puts "RESOURCE#initialize<#{self.object_id}> with layout: #{layout.class} #{layout.name} #{layout.object_id}, query: #{query}"
        @layout = layout
        @query = query
      end

			def each(&block)
			  call.each(&block)
			end
			
			# def to_a
			#   Array(call)
			# end
			
			def call
				#puts "RESOURCE#call<#{self.object_id}> @query: #{@query}"
				layout.send(*query)
			end
      
		  def find(*args)
		  	layout.send __method__, *args
		  	
		  	#self.class.new(layout, [__method__, *args])
		  	
		  	#@layout, @query = layout, [__method__, *args]
		  	#self
		  	
		  	#[self, self.class.new(layout, [__method__, *args])]
		  	
		  	#args
		  end
      
    end # Resource

    class Dataset
    	#include Enumerable
      include Charlatan.new(:data, kind: Array)

      def self.build(*args)
      	#puts "DATASET#build<#{self.object_id}>"
        new(Resource.new(*args))
      end
      
      # This is needed, otherwise charlatan returns a dataset wrapper around array returned from data.to_a.
      def to_a
      	data.to_a
      end

			def initialize(*args)
				#puts "DATASET#initialize<#{self.object_id}> with args: #{args.class} #{args} #{args.object_id}"
			  super
			end
    end # Dataset

  end # FMP
end # ROM

