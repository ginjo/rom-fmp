# This is an alternative version of rom-fmp, with all moduels & classes in a single file.

require 'logger'
require 'rom/gateway'
require 'rom/fmp/commands'
require 'rfm'
require 'yaml'

class Rfm::Layout
  def to_a
    all(:max_records=>10)
  end
  
  def each
    to_a.each
  end
end

module ROM
  module FMP
  
  
    class Gateway < ROM::Gateway
      attr_reader :datasets
      
      def initialize(*options)
        @datasets = Rfm.database(options[0].to_h.merge(FMRESULTSET_TEMPLATE).to_h)
      end
      
      def dataset(name)
        datasets[name.to_s]
      end
      
      def dataset?(name)
        datasets.layouts.key?(name.to_s)
      end
    end
  
  
    class Relation < ROM::Relation
      # we must configure adapter identifier here
      adapter :fmp

      forward :find, :any, :all
    end

    



  end # FMP
end # ROM
