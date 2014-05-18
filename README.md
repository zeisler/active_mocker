# ActiveMocker
[![Build Status](https://travis-ci.org/zeisler/active_mocker.png?branch=master)](https://travis-ci.org/zeisler/active_mocker)

Creates mocks from Active Record models. Allows your test suite to run very fast by not loading Rails or hooking to a database. It parse the schema definition and the definded methods on a model then saves a ruby file that can be included with a test. Mocks are regenerated when the schema is modified so your mocks will not go stale. This prevents the case where your units tests pass but production code is failing.

Example from a real app

		Finished in 0.54599 seconds
		190 examples, 0 failures

## Installation

Add this line to your application's Gemfile:

    gem 'active_mocker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_mocker


### Setup
  config/initializers/active_mocker.rb

    ActiveMocker::Generate.configure do |config|
      # Required Options
      config.schema_file = File.join(Rails.root, 'db/schema.rb')
      config.model_dir   = File.join(Rails.root, 'app/models')
      config.mock_dir    = File.join(Rails.root, 'spec/mocks')
      # Logging
      config.logger      = Rails.logger
    end

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

 db/schema.rb

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
    

 spec/models/person_spec.rb

    load 'spec/mocks/person_mock.rb'

    PersonMock.column_names
        => ["id", "account_id", "first_name", "last_name", "address", "city"]

    person_mock = PersonMock.new(first_name: "Dustin", last_name: "Zeisler", account: ActiveMocker.mock('Account').new)
        => "#<PersonMock id: nil, account_id: nil, first_name: \"Dustin\", last_name: \"Zeisler\", address: nil, city: nil>"

     person_mock.first_name
        => "Dustin"

### When schema.rb changes, the mock fails

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

     PersonMock.new(first_name: "Dustin", last_name: "Zeisler")
             =>#<RuntimeError Rejected params: {"first_name"=>"Dustin", "last_name"=>"Zeisler"} for PersonMock>


### Mocking instance and class methods

     person_mock.bar('baz')
        => RuntimeError: ::bar is not Implemented for Class: PersonMock

     person_mock.mock_instance_method(:bar) do  |name, type=nil|
        "Now implemented with #{name} and #{type}"
     end

     person_mock.new.bar('foo', 'type')
        => "Now implemented with foo and type"

     person_mock.mock_class_method(:bar) do
       "Now implemented"
     end

### When the model changes, the mock fails

 app/models/person.rb

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
      => NoMethodError: undefined method `bar' for class `PersonMock'

### ActiveRecord supported methods
**class methods**
  
* new
  * create
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

**instance methods**
  
* attributes
  * update
  * save
  * write_attribute - (private, can be used within an included module)
  * read_attribute  - (private)

**has_many associations**
  
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

  **Schema/Migration Option Support**
 
 * All schema types are supported and on initalization coerced by Virtus. If coercsion fails the passed value will be retained.
 * Default value 

### Known Limitations

* Model names and table names must follow the default ActiveRecord naming pattern.
* Included/extended module methods will not be included on the mock. I suggest you keep domain logic out of the model and only add database queries. Domain logic can be put into modules and then included into the mock during test setup. 
* Deleting one record at a time is not support, this is a limitation of ActiveHash.
* Queries will not call other mocks classes, for example when using `where` all attributes must reside inside of each record.

## Inspiration
Thanks to Jeff Olfert for being my original inspiration for this project.

## Contributing

1. Fork it ( http://github.com/zeisler/active_mocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
