require 'rom'
#require 'rom/fmp/header'
#require 'rom/fmp/relation/class_methods'
#require 'rom/fmp/relation/inspection'
#require 'rom/fmp/relation/associations'

module ROM
  module FMP
  
    class Relation < ROM::Relation
      include Enumerable
      # we must configure adapter identifier here
      adapter :fmp

      #forward :find, :all, :count, :create, :update, :delete
      forward :find, :all, :create
      
            
      def update(attributes)
        #collect{|r| dataset.update(r['record_id'], attributes).first}
        dataset.update(attributes, self.to_a)
      end
      
      def delete
        #collect{|r| dataset.delete(r['record_id']).first}
        dataset.delete(self.to_a)
      end
      
      def count
        dataset.count
      end
            
    end
    
  end
end
