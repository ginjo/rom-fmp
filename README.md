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
      adapter:            'fmp',
      host:               'my.fm.server.com',
      account_name:       'my_account',
      password:           '12345',
      database:           'MyFmpDatabase',  
    }

    ROM.use(:auto_registration)
    ROM.setup(:fmp, DB_CONFIG)

    class Users < ROM::Relation[:fmp]
      register_as :users
      dataset :user_xml # Filemaker layout name.

      def by_login(name)
        find(:login=>name.to_s)
      end

      def activated
        find(:activated_at=>'>1/1/2000')
      end

    end

    rom_env = ROM.finalize.env

    rom_users_relation = rom_env.relation(:users)

    activated_users_by_login = rom_users_relation.activated.by_login

    activated_users_by_login.call('bill').to_a
    activated_users_by_login.('bill').to_a
    activated_users_by_login['bill'].to_a

