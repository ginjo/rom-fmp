require 'charlatan'

# TODO: Same top-level dataset sticks around for unrelated calls. I don't think that is good.

module ROM
  module FMP
    # Filemaker dataset
    #
    # @api public
    class Dataset
    	attr_accessor :query
      include Charlatan.new(:data, kind: Array)
      
      def find(*args)
      	@query = [__method__, *args]
      	self
      end

			def each(&block)
				self.class.new(@data.send(*@query).each(&block))
				#@data.send(*@query).each(&block)
			end
			
			def to_a
				#self.class.new(@data.send(*@query).to_a)
				@data.send(*@query).to_a
			end
			
      def join(*args)
      	puts "JOINING!!!"
        left, right = args.size > 1 ? args : [self, args.first]

        join_map = left.each_with_object({}) { |tuple, h|
          others = right.to_a.find_all { |t| (tuple.to_a & t.to_a).any? }
          (h[tuple] ||= []).concat(others)
        }

        tuples = left.flat_map { |tuple|
          join_map[tuple].map { |other| tuple.merge(other) }
        }

        self.class.new(tuples, row_proc)
      end
      
    end # Dataset

  end # FMP
end # ROM
