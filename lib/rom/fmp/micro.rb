# This is an alternative version of rom-fmp, with all moduels & classes in a single file.

require 'logger'
require 'rom/gateway'
require 'rom/fmp/commands'
require 'rfm'
require 'yaml'


module ROM
  module FMP
  
  
    class Gateway < ROM::Gateway
      attr_reader :datasets
      
      def initialize(options)
        @datasets = Rfm.database(options.to_h.merge(FMRESULTSET_TEMPLATE).to_h)
      end
      
      def dataset(name)
        datasets[name]
      end
      
      def dataset?(name)
        datasets.layouts.key?(name)
      end
    end
  
  
    class Relation < ROM::Relation
      # we must configure adapter identifier here
      adapter :fmp

      forward :find, :any, :all
    end

    



  end # FMP
end # ROM
