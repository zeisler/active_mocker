# ActiveMocker
[![Build Status](https://travis-ci.org/zeisler/active_mocker.png?branch=master)](https://travis-ci.org/zeisler/active_mocker)
[![Code Climate](https://codeclimate.com/github/zeisler/active_mocker.png)](https://codeclimate.com/github/zeisler/active_mocker)

Creates mocks from Active Record models. Allows your test suite to run very fast by not loading Rails or hooking to a database. It parse the schema definition and the defined methods on a model then saves a ruby file that can be included with a test. Mocks are regenerated when the schema is modified so your mocks will not go stale. This prevents the case where your units tests pass but production code is failing.

Example from a real app

		Finished in 0.54599 seconds
		190 examples, 0 failures


------------------------------------------

* [Installation](#installation)
* [Setup](#setup)
* [Dependencies](#dependencies)
* [Usage](#usage)
* [Mocking Methods](#mocking-methods)
* [Clearing Mocks](#clearing-mocks)
* [ActiveRecord supported methods](#activerecord-supported-methods)
* [Known Limitations](#known-limitations)
* [Inspiration](#inspiration)
* [Contributing](#contributing)


------------------------------------------


## Installation

Add this line to your application's Gemfile:

    gem 'active_mocker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_mocker

## Dependencies
* Tested with Rails 4.1 may work with older versions but not supported.
* Requires Ruby MRI =< 2.0.


## Setup

### Configure the Mock Generator
  config/initializers/active_mocker.rb

    ActiveMocker::Generate.configure do |config|
      # Required Options
      config.schema_file = File.join(Rails.root, 'db/schema.rb')
      config.model_dir   = File.join(Rails.root, 'app/models')
      config.mock_dir    = File.join(Rails.root, 'spec/mocks')
      # Logging
      config.logger      = Rails.logger
    end

### Create a Rake Task to Auto Regenerate Mocks

Here is an example of a rake task to regenerate mocks after every schema modifiation. If the model changes this rake task needs to be called manually. You could add a file watcher for when your models change and have it run the rake task.

  lib/tasks/active_mocker.rake

    task rebuild_mocks: :environment do
      puts 'rebuilding mocks'
      ActiveMocker.create_mocks
    end

    ['db:schema:load', 'db:migrate', 'db:reset'].each do |task|
      Rake::Task[task].enhance do
        Rake::Task['rebuild_mocks'].invoke
      end
    end

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
 db/schema.rb

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

     PersonMock.mock_instance_method(:bar) do  |name, type=nil|
        "Now implemented with #{name} and #{type}"
     end
     

### Instance Methods

      PersonMock.new.bar('foo', 'type')
        => "Now implemented with foo and type"

     person_mock.mock_class_method(:bar) do
        "Now implemented"
     end

### When the model changes, the mock fails
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

    person_mock.mock_instance_method(:bar) do  |name, type=nil|
      "Now implemented with #{name} and #{type}"
    end
      => NoMethodError: undefined method `bar' for class `PersonMock'

### Clearing Mocks

Deletes All Records and Clears Mocked Methods
    
    PersonMock.clear_mock     
    
Clears all Loaded Mocks - (Use in after(:all) to keep state from leaking to other tests.)
    
    ActiveMocker::LoadedMocks.clear_all

Deletes All Records for Loaded Mocks - (Useful in after(:each) to clean up state between examples)
    
    ActiveMocker::LoadedMocks.delete_all
    
List All Loaded Mocks
    
    ActiveMocker::LoadedMocks.all
    		=> { 'PersonMock' => PersonMock } 


### ActiveRecord supported methods
**class methods**

  * new
  * create/create!
  * column_names/attribute_names
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
  * all
  * count
  * first/last
  * limit

**instance methods**
  
  * attributes
  * update
  * save/save!
  * write_attribute/read_attribute - (private, can be used within an included module)
  * delete

**has_many associations/Collections**

  * empty?
  * length/size/count
  * uniq
  * replace
  * first/last
  * concat
  * include
  * push
  * clear
  * take
  * average(:field_name)
  * minimum(:field_name)
  * maximum(:field_name)
  * sum(:field_name)
  * find
  * find_by/find_by!
  * where(conditions_hash)
  * where(key: array_of_values)
  * where.not(conditions_hash)
  * update_all
  * delete_all
  * order(:field_name)
  * reverse_order
  * limit

### Schema/Migration Option Support
* All schema types are supported and on initalization coerced by Virtus. If coercsion fails the passed value will be retained.
* Default value

### Known Limitations
* Model names and table names must follow the default ActiveRecord naming pattern.
* Included/extended module methods will not be included on the mock. I suggest you keep domain logic out of the model and only add database queries. Domain logic can be put into modules and then included into the mock during test setup.
* Queries will not call other mocks classes, for example when using `where` all attributes must reside inside of each record.
* Creation of association like `User.create_friend` or `User.build_friend` are not supported. If you need this functionality use rspec's stub any instance.
* Validation are not present in mocks.
* CONSTANTS are not present in the mocks. This feature is planed for a future release. 
* Associating objects together will not associate their ids nor will associating ids associate the objects together. This feature is planed for a future release.  

## Inspiration
Thanks to Jeff Olfert for being my original inspiration for this project.

## Contributing
Your contribution are welcome!

1. Fork it ( http://github.com/zeisler/active_mocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
