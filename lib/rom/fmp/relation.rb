require 'rom'
#require 'rom/fmp/header'
#require 'rom/fmp/relation/class_methods'
#require 'rom/fmp/relation/inspection'
#require 'rom/fmp/relation/associations'

module ROM
  module FMP
  
    class Relation < ROM::Relation
      # we must configure adapter identifier here
      adapter :fmp

      forward :find, :all, :count, :create, :update, :delete
      
      # Added to help commands on loaded relations,
      # but is not currently used.
      
      def map
        out=[]
        each {|x| out << yield(x)}
        out
      end
    end
    
  end
end
