# ActiveMocker
[![Gem Version](https://badge.fury.io/rb/active_mocker.svg)](http://badge.fury.io/rb/active_mocker)
[![Build Status](https://travis-ci.org/zeisler/active_mocker.svg?branch=master)](https://travis-ci.org/zeisler/active_mocker)
[![Gitter chat](https://badges.gitter.im/zeisler/active_mocker.svg)](https://gitter.im/zeisler/active_mocker)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

## Description
Creates stub classes from any ActiveRecord model. 

By using stubs in your tests you don't need to load Rails or the database, sometimes resulting in a 10x speed improvement. 

ActiveMocker analyzes the methods and database columns to generate a Ruby class file. 

The stub file can be run standalone and comes included with many useful parts of ActiveRecord.

Stubbed out methods contain their original argument signatures or ActiveMocker's friendly code can be brought over in its entirety.

Mocks are regenerated when the schema is modified so your mocks won't go stale, preventing the case where your unit tests pass but production code fails.

*Examples from a real app*

		Finished in 1 seconds
		374 examples, 0 failures

## Around the web
["Mocking ActiveRecord with ActiveMocker" by Envy](https://web.archive.org/web/20150511052653/http://madewithenvy.com/ecosystem/articles/2015/mocking-activerecord-with-activemocker/)

------------------------------------------

* [Documentation](#documentation)
* [Contact](#contact)
* [Installation](#installation)
* [Setup](#setup)
  * [Generate](#generate_mocks)
* [Dependencies](#dependencies)
* [Usage](#usage)
* [Optional Features](#optional-features)
* [Mocking Methods](#mocking-methods)
* [Managing Mocks](#managing-mocks)
* [ActiveRecord supported methods](#activerecord-supported-methods)
* [Known Limitations](#known-limitations)
* [Inspiration](#inspiration)
* [Contributing](#contributing)


---------------------------

## Documentation [![Inline docs](http://inch-ci.org/github/zeisler/active_mocker.png?branch=master)](http://inch-ci.org/github/zeisler/active_mocker)

[rdoc](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker)

------------------------------------------

## Contact

Ask a question in the [chat room](https://gitter.im/zeisler/active_mocker).

------------------------


## Installation

Add this line to your application's Gemfile:
```ruby
group :development, :test do
  gem 'active_mocker'
end
```
It needs to be in development as well as test groups, as the development environment is where mocks will be generated.
Then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_mocker

## Dependencies
* Tested with Rails 4.x, 5.x, 6.x
* Requires Ruby MRI >= 2.4.x

## Setup


  See [example_rails_app](https://github.com/zeisler/active_mocker/tree/master/example_rails_app) for complete setup.


### Generate Mocks

Running this rake task builds/rebuilds the mocks. It will be ran automatically after every schema modification. If the model changes, this rake task needs to be called manually. You could add a file watcher for when your models change and have it run the rake task.

    rake active_mocker:build

## Usage
```ruby
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
```
--------------
```ruby
#app/models/person.rb

class Person < ActiveRecord::Base
  belongs_to :account

  def self.bar(name, type=nil)
	puts name
  end

end
 ```
----------------- 
  
### Using With Rspec, --tag active_mocker:true

```ruby
require 'rspec'
require 'active_mocker/rspec_helper'
require 'spec/mocks/person_mock'
require 'spec/mocks/account_mock'

describe 'Example', active_mocker:true do

  before do
	Person.create # stubbed for PersonMock.create
  end

end
```       
----------

* Assigning the tag `active_mocker:true` will stub any ActiveRecord model Constants for Mock classes in an `it` or a `before/after(:each)`. This removes any need for dependency injection. Write tests and code like you would normally.
* To stub any Constants in `before(:all)`, `after(:all)` use `active_mocker.find('ClassName')`.
* Mock state will be cleaned up for you in an `after(:all)`. To clean state by yourself, use `active_mocker.delete_all`.

---------
    
```ruby
Person.column_names
  => ["id", "account_id", "first_name", "last_name", "address", "city"]

person = Person.new( first_name:  "Dustin", 
    				 last_name:   "Zeisler", 
    				 account:      Account.new )
  => "#<PersonMock id: nil, account_id: nil, first_name: "Dustin", last_name: "Zeisler", address: nil, city: nil>"

person.first_name
  => "Dustin"
```

### When schema.rb changes, the mock fails
(After `rake db:migrate` is called the mocks will be regenerated.)

```ruby
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
```
--------------

```ruby
Person.new(first_name: "Dustin", last_name: "Zeisler")
  =>#<UnknownAttributeError unknown attribute: first_name >
```

### Creating Custom collections

If you want to create a custom set of records that is not part of the global collection for model. (ie. for stubbing in a test)

```ruby
User::ScopeRelation.new([User.new, User.new])
```

This gives the full query API (ie. `find_by`, `where`, etc). 

This is not a feature available in ActiveRecord, so do not include this where you intend to swap for ActiveRecord.


## Optional Features

Use theses defaults if you are starting fresh

```ruby
ActiveMocker::LoadedMocks.features.enable(:timestamps)
ActiveMocker::LoadedMocks.features.enable(:delete_all_before_example)
ActiveMocker::LoadedMocks.features.enable(:stub_active_record_exceptions)
```

### timestamps

  Enables `created_at` and `updated_at` to be updated on save and create

### delete_all_before_example

  When using "active_mocker/rspec_helper", it deletes all records from all mocks before each example.

### stub_active_record_exceptions

  When requiring "active_mocker/rspec_helper", and adding `active_mocker: true` to the `describe` metadata, these errors will be auto stubbed:
  
  * ActiveRecord::RecordNotFound
  * ActiveRecord::RecordNotUnique
  * ActiveRecord::UnknownAttributeError
    
### Copy over Mock safe methods into the generated mock
  
  Adding the comment `ActiveMocker.safe_methods` at the top of a class marks it as safe to copy to the mock.
  Be careful. It should not contain anything that ActiveMocker cannot run.
  
  ```ruby
  # ActiveMocker.safe_methods(scopes: [], instance_methods: [:full_name], class_methods: [])
  class User
    def full_name
      "#{first_name} + #{last_name}"
    end
  end
  ```

## Mocking Methods

#### Rspec 3 Mocks - verify double
Verifying doubles is a stricter alternative to normal doubles that provides guarantees about
what is being verified. When using verifying doubles, RSpec will check if the methods
being stubbed are actually present on the underlying object if it is available.
[rspec-mocks/docs/verifying-doubles](https://relishapp.com/rspec/rspec-mocks/docs/verifying-doubles)
```ruby
RSpec.configure do |config|
  config.mock_framework = :rspec
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end
```

```ruby
Person.bar('baz')
  => NotImplementedError: ::bar is not Implemented for Class :PersonMock. To continue stub the method.

allow(Person).to receive(:bar) do |name, type=nil|
  "Now implemented with #{name} and #{type}"
end

Person.bar('foo', 'type')
=> "Now implemented with foo and type"
```

#### When the model changes, the mock fails
(Requires a regeneration of the mocks files.)

```ruby
#app/models/person.rb

class Person < ActiveRecord::Base
  belongs_to :account

  def self.bar(name)
    puts name
  end

end
```

--------------
```ruby
Person.bar('foo', 'type')
  => ArgumentError: wrong number of arguments (2 for 1)
```
----------------
```ruby
#app/models/person.rb

class Person < ActiveRecord::Base
  belongs_to :account

  def self.foo(name, type=nil)
    puts name
  end

end
 ```   
--------------
```ruby
allow(Person).to receive(:bar) do |name, type=nil|
  "Now implemented with #{name} and #{type}"
end
=> RSpec::Mocks::MockExpectationError: PersonMock does not implement: bar
 ```     
### Constants and Modules

* Any locally defined modules will not be included or extended. It can be disabled by `ActiveMocker::Config.disable_modules_and_constants = true`

---------------
```ruby
class Person < ActiveRecord::Base
  CONSTANT_VALUE = 13
end
```
-----------------------
```ruby
PersonMock::CONSTANT_VALUE
  => 13
```

### Scoped Methods 
* Any chained scoped methods will be available when the mock file that defines it is required. When called, it raises a `NotImplementedError`. Stub the method with a value to continue.

### Managing Mocks  

```ruby    
require "active_mocker/rspec_helper"

active_mocker.delete_all # Delete all records from loaded mocks

active_mocker.find("User") # Find a mock by model name. Useful in before(:all)/after(:all) where automatic constant stubbing is unavailable.

active_mocker.mocks.except("User").delete_all # Delete all loaded mock expect the User mock.

```
### ActiveRecord supported methods

See [Documentation](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker) for a complete list of methods and usage.

**Class Methods** - [docs](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker/Mock/Base)

  * new
  * create/create!
  * column_names/attribute_names
  * delete_all/destroy_all
  * table_name
  * slice
  * alias_attributes
  
**Query Methods** - [docs](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker/Mock/Queries)

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
  * none
  
**Relation Methods** - [docs](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker/Mock/Collection)
  * concat
  * include
  * push
  * clear
  * take
  * empty?
  * replace
  * any?
  * many?

**instance methods** - [docs](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker/Mock/Queries)
  
  * attributes
  * update
  * save/save!
  * write_attribute/read_attribute
  * delete
  * new_record?
  * persisted?
  * reload
  * attribute_names
  * attribute_present?
  * has_attribute?
  * slice
  * attribute_alias?
  * alias_attributes
  * touch

**has_one/belongs_to/has_many**

  * build_< association >
  * create_< association >
  * create_< association >!
  * < association >.create
  * < association >.build

### Schema/Migration Option Support
* A db/schema.rb is not required.
* All schema types are supported and coerced by [Virtus](https://github.com/solnic/virtus). If coercion fails, the passed value will be retained.
* Default value is supported.
* Scale and Precision are not supported.

### Known Limitations
* Namespaced modules are not currently supported.
* When an association is set in one object it may not always be reflective in other objects, especially when it is a non standard/custom association. See [test_rails_4_app/spec/active_record_compatible_api.rb](https://github.com/zeisler/active_mocker/blob/master/test_rails_4_app/spec/active_record_compatible_api.rb) for a complete list of supported associations. 
* Validation/Callbacks are not supported.
* Sql queries, joins, etc will never be supported.
* A record that has been created and then is modified will persist changes without calling `#save`. Beware of this difference.
* This is not a full replacement for ActiveRecord.
* Primary key will always default to `id`. If this is causing a problem, feel free to open an issue (or even better, a PR =)). 

## Inspiration
Thanks to Jeff Olfert for being my original inspiration for this project.

## Contributing
Your contributions are welcome!

1. Fork it ( http://github.com/zeisler/active_mocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
