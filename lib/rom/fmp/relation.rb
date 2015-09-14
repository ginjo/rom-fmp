#require 'rom/fmp/header'

#require 'rom/fmp/relation/class_methods'
#require 'rom/fmp/relation/inspection'
#require 'rom/fmp/relation/associations'

module ROM
  module FMP
    class Relation < ROM::Relation
      adapter :fmp
      forward :find, :where, :all, :any, :count, :to_a
    end
  end
end
