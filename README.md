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

    ActiveMocker.configure do |config|
      # Required Options
      config.schema_file = "#{APP_ROOT}/db/schema.rb"
      config.model_dir   = "#{APP_ROOT}/app/models"
      # Additional Options
      config.schema_attributes   = true  #default
      config.model_attributes    = true  #default
      # Logging
      config.log_level = Logger::WARN       #default
    end

    ActiveMocker.mock('Person')
        => PersonMock

    PersonMock.column_names
        => ["account_id", "first_name", "last_name", "address", "city"]

    person_mock = PersonMock.new(first_name: "Dustin", last_name: "Zeisler", account: ActiveMocker.mock('Account').new)
        => #<PersonMock @first_name="Dustin", @last_name="Zeisler">

     person_mock.first_name
        => "Dustin"

### When schema.rb changes, the mock fails

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


     person_mock.mock_instance_method(:bar) do  |name, type=nil|
        "Now implemented with #{name} and #{type}"
     end

     person_mock.new.bar('foo', 'type')
        => "Now implemented with foo and type"

     person_mock.mock_class_method(:baz) do
       "Now implemented"
     end

### When the model changes, the mock fails

    #app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def bar(name)
        puts name
      end

    end

    person_mock.new.bar('foo', 'type')
      => ArgumentError: wrong number of arguments (2 for 1)


    app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def foo(name, type=nil)
        puts name
      end

    end

    person_mock.mock_instance_method(:bar) do  |name, type=nil|
      "Now implemented with #{name} and #{type}"
    end
      => NameError: undefined method `bar' for class `PersonMock'

### ActiveRecord supported methods
**Class methods**
  
  * create/new
  * column_names
  * find
  * find_by
  * find_by!
  * find_or_create_by
  * find_or_initialize_by
  * where - (only supports hash input)
  * delete_all/destroy_all
  * all
  * count
  * first/last

**Instance methods**
  
  * attributes
  * update
  * save
  * write_attribute - (private)
  * read_attribute  - (private)

 **Collection Associations**
 
  * last/first
  * sum(attribute)
  * <<
  * Enumerable methods

### Known Limitations

* **::mock** model names and table names must follow the default ActiveRecord naming pattern.
* Included/extended module methods will not be included on the mock.

## Inspiration
Thanks to Jeff Olfert for being my original inspiration for this project.

## Contributing

1. Fork it ( http://github.com/zeisler/active_mocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
