# ActiveMocker
[![Build Status](https://travis-ci.org/zeisler/active_mocker.png?branch=master)](https://travis-ci.org/zeisler/active_mocker)

Create mocks from active record models without loading rails or running a database.


## Installation

Add this line to your application's Gemfile:

    gem 'active_mocker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_mocker

## Usage


    #db/schema.rb

    ActiveRecord::Schema.define(version: 20140327205359) do

      create_table "people", force: true do |t|
        t.integer  "account_id"
        t.string   "first_name",        limit: 128
        t.string   "last_name",         limit: 128
        t.string   "address",           limit: 200
        t.string   "city",              limit: 100
      end

    end

    #app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def bar(name, type=nil)
        puts bar
      end

    end

    require 'active_mocker'

    ActiveMocker::Base.configure do |config|
      config.schema_file = 'file is being inject as string'
      config.model_dir   = 'file is being inject as string'
    # Depenency injection
      config.schema_file_reader = schema_file
      config.model_file_reader  = model_file
    # Additional Options
      config.active_hash_as_base = false #default
      config.schema_attributes   = true  #default
      config.model_relationships = true  #default
      config.model_methods       = true  #default
      config.mass_assignment     = true  #default
    end

    mocker = ActiveMocker::Base.new({schema: {path: [path to schema.rb file]},
                                     model:  {path: [dir of rails models]}}

    mocker.mock('Person')
        => PersonMock

    PersonMock.column_names
        => ["account_id", "first_name", "last_name", "address", "city"]

    person_mock = PersonMock.new(first_name: "Dustin", last_name: "Zeisler", account: mocker.mock('Account').new)
        => #<PersonMock @first_name="Dustin", @last_name="Zeisler">

     person_mock.first_name
        => "Dustin"

### When schema.rb changes the mock fails

     #db/schema.rb

     ActiveRecord::Schema.define(version: 20140327205359) do

       create_table "people", force: true do |t|
         t.integer  "account_id"
         t.string   "f_name",        limit: 128
         t.string   "l_name",        limit: 128
         t.string   "address",       limit: 200
         t.string   "city",          limit: 100
       end

     end

     person_mock = PersonMock.new(first_name: "Dustin", last_name: "Zeisler", account: AccountMock.new)
             => NoMethodError: undefined method `first_name=' for #<PersonMock:0x007f860abf6b10>


### Mocking instance methods

     person_mock.bar
        => ArgumentError: wrong number of arguments (0 for 1..2)

     person_mock.bar('baz')
        => RuntimeError: #bar is not Implemented for Class: PersonMock


     mock_class.mock_instance_method(:bar) do  |name, type=nil|
        "Now implemented with #{name} and #{type}"
     end

     mock_class.new.bar('foo', 'type')
        => "Now implemented with foo and type"

### When the model changes the mock fails

    #app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def bar(name)
        puts bar
      end

    end

     mock_class.new.bar('foo', 'type')
        => ArgumentError: wrong number of arguments (2 for 1)



### When the schema changes


## Contributing

1. Fork it ( http://github.com/<my-github-username>/active_mocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
