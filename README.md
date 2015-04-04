# rom-fmp

A filemaker adapter for the rom-rb data mapping & persistence gem.
See [rom-rb](https://github.com/rom-rb) on github or [rom-rb.org](http://rom-rb.org)
for more information about Ruby Object Mapper.

## Installation

Add this line to your application's Gemfile:

    gem 'rom-fmp'


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rom-fmp

## Usage

    require 'rom/fmp'

    DB_CONFIG = {
      host:               'my.host.com',
      account_name:       'my_database_user_name',
      password:           'secret',
      database:           'my_fmp_database',
      ssl:                'true', 
    }

    ROM.setup(:fmp, DB_CONFIG)

    ROM.relation(:users)
    ROM.commands(:users) { define(:create) }
    ROM.mappers { define(:users) { register_as :entity; model name: 'User'; attribute :name } }

    @rom = ROM.finalize.env
    
    create_user = @rom.commands[:users].create
    user_mapper = @rom.mappers[:users].entity
    create_and_map = create_user.with(name: 'Jane') >> user_mapper

    puts create_and_map.call.inspect

