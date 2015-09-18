require 'rom'
require 'rfm'

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
    end # Gateway
    
  end # FMP
end # ROM
