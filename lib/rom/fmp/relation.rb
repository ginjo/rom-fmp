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
      forward :find, :all, :count, :create, :delete
      
      # Returns an instance of ROM::Relation::Loaded with:
      # source: a dataset containing all fmp resultsets from the operation.
      # collection: a dataset containing resultset records from the operation.
      # The result of this does not respond to :as. (you would need to return a source relation instead)
      def update(attributes)
        new_dataset = Dataset.new([]).concat(map{|tuple| dataset.update(tuple['record_id'], attributes).data})
        ROM::Relation::Loaded.new(new_dataset, new_dataset.map{|resultset| resultset.to_a}.flatten(1).to_a)
      end
      
    end
    
  end
end
