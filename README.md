# ActiveMocker
[![Gem Version](https://badge.fury.io/rb/active_mocker.svg)](http://badge.fury.io/rb/active_mocker)
[![Build Status](https://travis-ci.org/zeisler/active_mocker.png?branch=master)](https://travis-ci.org/zeisler/active_mocker)
[![Code Climate](https://codeclimate.com/github/zeisler/active_mocker.png)](https://codeclimate.com/github/zeisler/active_mocker)
[![Dependency Status](https://gemnasium.com/zeisler/active_mocker.svg)](https://gemnasium.com/zeisler/active_mocker)
[![Gitter chat](https://badges.gitter.im/zeisler/active_mocker.png)](https://gitter.im/zeisler/active_mocker)

ActiveMocker creates mocks classes from ActiveRecord models. Allowing your test suite to run very fast by not loading Rails or hooking to a database. It parses the schema definition and the defined methods on a model then saves a ruby file that can be included within a test. The mock can be run by themselves and include a partial implementation of ActiveRecord. Mocks are regenerated when the schema is modified so your mocks will not go stale. This prevents the case where your units tests pass but production code is failing.

Example from a real app

		Finished in 0.54599 seconds
		190 examples, 0 failures


------------------------------------------
* [Documentation](#documentation)
* [Contact](#contact)
* [Installation](#installation)
* [Setup](#setup)
  * [Generate](#generate_mocks)
* [Dependencies](#dependencies)
* [Usage](#usage)
* [Mocking Methods](#mocking-methods)
* [Managing Mocks](#managing-mocks)
* [ActiveRecord supported methods](#activerecord-supported-methods)
* [Known Limitations](#known-limitations)
* [Inspiration](#inspiration)
* [Contributing](#contributing)


---------------------------

## Documentation

[rdoc](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker)

------------------------------------------

## Contact

Ask a question in the [chat room](https://gitter.im/zeisler/active_mocker).

------------------------


## Installation

Add this line to your application's Gemfile:

    gem 'active_mocker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_mocker

## Dependencies
* Tested with Rails 4.1 may work with older versions but not supported.
* Requires Ruby MRI =< 2.1.


## Setup

### Generate Mocks

Running this rake task builds/rebuilds the mocks. It will be ran automatically after every schema modification. If the model changes this rake task needs to be called manually. You could add a file watcher for when your models change and have it run the rake task.

    rake active_mocker::build

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
--------------

    #app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def bar(name, type=nil)
        puts name
      end

      def self.bar
      end

    end
 
-----------------   

    #person_spec.rb

    require 'spec/mocks/person_mock.rb'
    require 'spec/mocks/account_mock.rb'

    PersonMock.column_names
        => ["id", "account_id", "first_name", "last_name", "address", "city"]

    person_mock = PersonMock.new( first_name:  "Dustin", 
    							  last_name:   "Zeisler", 
    							  account:      AccountMock.new )
        => "#<PersonMock id: nil, account_id: nil, first_name: "Dustin", last_name: "Zeisler, address: nil, city: nil>"

     person_mock.first_name
        => "Dustin"

### When schema.rb changes, the mock fails
(Requires a regeneration of the mocks files.)
 
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

--------------

    #person_spec.rb

     PersonMock.new(first_name: "Dustin", last_name: "Zeisler")
             =>#<RuntimeError Rejected params: {"first_name"=>"Dustin", "last_name"=>"Zeisler"} for PersonMock>

## Mocking Methods


### Class Methods

     PersonMock.bar('baz')
        => RuntimeError: ::bar is not Implemented for Class: PersonMock

     # Rspec 3 Mocks
     allow(PersonMock).to receive(:bar) do  |name, type=nil|
        "Now implemented with #{name} and #{type}"
     end
     

### Instance Methods

      PersonMock.new.bar('foo', 'type')
        => "Now implemented with foo and type"

      # Rspec 3 Mocks
      allow_any_instance_of(PersonMock).to receive(:bar) do
         "Now implemented"
      end


#### When the model changes, the mock fails
(Requires a regeneration of the mocks files.)

    #app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def bar(name)
        puts name
      end

    end
   
--------------

    #person_spec.rb

    person_mock.new.bar('foo', 'type')
      => ArgumentError: wrong number of arguments (2 for 1)

----------------

    #app/models/person.rb

    class Person < ActiveRecord::Base
      belongs_to :account

      def foo(name, type=nil)
        puts name
      end

    end
    
--------------

     #person_spec.rb

    # Rspec 3 Mocks
    allow(person_mock).to receive(:bar) do  |name, type=nil|
      "Now implemented with #{name} and #{type}"
    end
      => NoMethodError: undefined method `bar' for class `PersonMock'

### Managing Mocks

Rspec Tag - active_mocker:true
    require 'active_mocker/rspec_helper'
    
    describe 'Example', active_mocker:true do
    
       before do
          User.create # Is stubbed for UserMock.create
       end
    
    end
    
  * Assigning this tag will stub any ActiveRecord model Constants for Mock classes in any `it's` or `before(:each)`. This removes any need for dependency injection. Write tests and code like you would normally.
  * To stub any Constants in `before(:all)`, `after(:all)` use `mock_class('ClassName')`.
  * Calls `ActiveMocker::LoadedMocks.clear_all` `in after(:all)` block to clean up for other tests.

Deletes All Records
    
    PersonMock.delete_all     

Deletes All Records for Loaded Mocks - (Useful in after(:each) to clean up state between examples)
    
    ActiveMocker::LoadedMocks.delete_all

### Constants and included and extended Modules are Available.

	#app/models/person.rb

	class User < ActiveRecord::Base
	   CONSTANT_VALUE = 13
	end

-----------------------

	#user_spec.rb

	require 'spec/mocks/user_mock.rb'

	UserMock::CONSTANT_VALUE
		=> 13

### ActiveRecord supported methods
**class methods**

  * new
  * create/create!
  * column_names/attribute_names
  
**Query Methods**
  * all
  * find
  * find_by/find_by!
  * find_or_create_by
  * find_or_initialize_by
  * where(conditions_hash)
  * where(key: array_of_values)
  * where.not(conditions_hash)
  * delete_all/destroy_all
  * delete_all(conditions_hash)
  * destroy(id)/delete(id)
  * update_all
  * update(id, attributes)
  * count
  * uniq
  * first/last
  * average(:field_name)
  * minimum(:field_name)
  * maximum(:field_name)
  * sum(:field_name)
  * order(:field_name)
  * reverse_order
  * limit
  
**Relation Methods**
  * concat
  * include
  * push
  * clear
  * take
  * empty?
  * replace
  * any?
  * many?

**instance methods**
  
  * attributes
  * update
  * save/save!
  * write_attribute/read_attribute - (protected, can be used within modules)
  * delete
  * new_record?
  * persisted?
  * reload

**has_one/belongs_to/has_many**

  * build_< association >
  * create_< association >
  * create_< association >!
  * < association >.create
  * < association >.build
  

### Schema/Migration Option Support
* All schema types are supported and coerced by [Virtus](https://github.com/solnic/virtus). If coercion fails the passed value will be retained.
* Default value
* Scale and Precision not supported.

### Known Limitations
* Model names and table names must follow the default ActiveRecord naming pattern.
* Whatever associations are setup in one mock object will not be reflected in any other objects. 
    * There partial support for this feature in v1.6 when 'ActiveMocker::Mock.config.experimental = true' is set. 

* Validation are not present in mocks.
* Sql queries, joins, etc will never be supported.

## Inspiration
Thanks to Jeff Olfert for being my original inspiration for this project.

## Contributing
Your contribution are welcome!

1. Fork it ( http://github.com/zeisler/active_mocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
