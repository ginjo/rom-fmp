$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rom/fmp'

DB_CONFIG = {
  adapter:            'fmp',
  host:               'cerne03.cernesystems.com',
  account_name:       'test',
  password:           'test',
  database:           'PUBLIC',
  ssl:                'true',
  port:               443,
  root_cert:          false,
  log_actions:        true,
  log_responses:      false		  
}
