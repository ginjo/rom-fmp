###  NOT USED YET  ###

require 'rom/commands'

# This was from sql adapter
# module ROM
#   module FMP
#     module Commands
#       ERRORS = [
#         FMP::ConstraintError
#         #Sequel::NotNullConstraintViolation
#       ].freeze
#     end
#   end
# end

require 'rom/fmp/commands/instance_methods'
require 'rom/fmp/commands/create'
require 'rom/fmp/commands/update'
require 'rom/fmp/commands/delete'
#require 'rom/fmp/commands_ext/postgres'
