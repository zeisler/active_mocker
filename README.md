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
        puts name
      end

      def self.bar
      end

    end

    require 'active_mocker'

    ActiveMocker::Base.configure do |config|
    # Required Options
      config.schema_file = "#{APP_ROOT}/db/schema.rb"
      config.model_dir   = "#{APP_ROOT}/app/models"
    # Additional Options
      config.active_hash_as_base = false #default
      config.schema_attributes   = true  #default
      config.model_relationships = true  #default
      config.model_methods       = true  #default
      config.mass_assignment     = true  #default
     # Logging
      config.log_level = Logger::WARN    #default
    end

    ActiveMocker::Base.mock('Person')
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


### Mocking instance and class methods

     person_mock.bar
        => ArgumentError: wrong number of arguments (0 for 1..2)

     person_mock.bar('baz')
        => RuntimeError: #bar is not Implemented for Class: PersonMock


     mock_class.mock_instance_method(:bar) do  |name, type=nil|
        "Now implemented with #{name} and #{type}"
     end

     mock_class.new.bar('foo', 'type')
        => "Now implemented with foo and type"

     mock_class.mock_class_method(:baz) do
       "Now implemented"
     end

### When the model changes the mock fails

    #app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def bar(name)
        puts name
      end

    end

    mock_class.new.bar('foo', 'type')
      => ArgumentError: wrong number of arguments (2 for 1)


    app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def foo(name, type=nil)
        puts name
      end

    end

    mock_class.mock_instance_method(:bar) do  |name, type=nil|
      "Now implemented with #{name} and #{type}"
    end
      => NameError: undefined method `bar' for class `PersonMock'

### Enable ActiveHash support
ActiveHash is a simple base class that allows you to use a ruby hash as a readonly datasource for an ActiveRecord-like model.
  [zilkey/active_hash](https://github.com/zilkey/active_hash)


    ActiveMocker::Base.configure do |config|
      config.active_hash_as_base = true
    end

    ActiveMocker::Base.mock('Person').superclass
      => ActiveHash::Base

    dustin = PersonMock.create(first_name: 'Dustin')
      => #<PersonMock @attributes={:first_name=>"Dustin" :id=>1}>

    PersonMock.all
      => [#<PersonMock: @attributes={:first_name=>"Dustin", :id=>1}>]

     dustin.last_name = 'Zeisler'
       => "Zeisler"

     dustin.save
       => true

### Additional ActiveHash extentions for matching ActiveRecord


#### #update method

    person = PersonMock.create(first_name: 'Justin')

    person.update(first_name: 'Dustin')

    person.first_name
        => 'Dustin'


#### ::destroy_all

    mock_class.create

    mock_class.count
        => 1

    mock_class.destroy_all

    mock_class.count
        => 0


    ::find_by

    person = PersonMock.create(first_name: 'Dustin')

    PersonMock.find_by(first_name: 'Dustin') == person
      => true


### Known Limitations

**::mock** model names and table names must follow the default ActiveRecord naming pattern.

## Contributing

1. Fork it ( http://github.com/zeisler/active_mocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
