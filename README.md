# ActiveMocker
[![Gem Version](https://badge.fury.io/rb/active_mocker.svg)](http://badge.fury.io/rb/active_mocker)
[![Build Status](https://travis-ci.org/zeisler/active_mocker.png?branch=master)](https://travis-ci.org/zeisler/active_mocker)
[![Code Climate](https://codeclimate.com/github/zeisler/active_mocker.png)](https://codeclimate.com/github/zeisler/active_mocker)
[![Dependency Status](https://gemnasium.com/zeisler/active_mocker.svg)](https://gemnasium.com/zeisler/active_mocker)
[![Gitter chat](https://badges.gitter.im/zeisler/active_mocker.png)](https://gitter.im/zeisler/active_mocker)

ActiveMocker creates mocks classes from ActiveRecord models. Allowing your test suite to run very fast by not loading Rails a database. It parses the schema.rb and the defined methods on a model then generates a ruby file that can be included within a test. The mock file can be run by themselves and come with a partial implementation of ActiveRecord. Attributes and associations can be used just the same as in ActiveRecord. Methods will have the correct arguments but raise an NotImplementedError when called. Mocks are regenerated when the schema is modified so your mocks will not go stale; preventing the case where your units tests pass but production code fails.

Examples from a real apps

		Finished in 1 seconds
		374 examples, 0 failures


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
It needs to be in development as well as test because development is where mocks will be generated.
And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_mocker

## Dependencies
* Tested with Rails 4.0, 4.1, 4.2beta2
* Requires Ruby MRI >= 2.1.


## Setup


  See [example_rails_app](https://github.com/zeisler/active_mocker/tree/master/example_rails_app) for complete setup.


### Generate Mocks

Running this rake task builds/rebuilds the mocks. It will be ran automatically after every schema modification. If the model changes this rake task needs to be called manually. You could add a file watcher for when your models change and have it run the rake task.

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

  def bar(name, type=nil)
	puts name
  end

  def self.bar
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
* To stub any Constants in `before(:all)`, `after(:all)` use `mock_class('ClassName')`.
* Mock state will be cleaned up for you in an `after(:all)`. To clean state your self use `ActiveMocker::LoadedMocks.delete_all`.

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

## Mocking Methods

#### Rspec 3 Mocks - verify double
Verifying doubles are a stricter alternative to normal doubles that provide guarantees about
what is being verified. When using verifying doubles, RSpec will check that the methods
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

# Rspec 3 mock class method
allow_any_instance_of(Person).to receive(:bar) do
  "Now implemented"
end
```

#### When the model changes, the mock fails
(Requires a regeneration of the mocks files.)

```ruby
#app/models/person.rb

class Person < ActiveRecord::Base
  belongs_to :account

  def bar(name)
    puts name
  end

end
```

--------------
```ruby
Person.new.bar('foo', 'type')
  => ArgumentError: wrong number of arguments (2 for 1)
```
----------------
```ruby
#app/models/person.rb

class Person < ActiveRecord::Base
  belongs_to :account

  def foo(name, type=nil)
    puts name
  end

end
 ```   
--------------
```ruby
allow(person).to receive(:bar) do |name, type=nil|
  "Now implemented with #{name} and #{type}"
end
=> NoMethodError : undefined method `bar' for class ` PersonMock '
 ```     
### Constants and Modules

* Any locally defined modules will not be included or extended.

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
* Any chained scoped methods will be available when the mock file that defines it is required. When called it raises a `NotImplementedError`, stub the method with a value to continue.

### Managing Mocks  

Deletes All Records for Loaded Mocks - (Useful in after(:each) to clean up state between examples)
```ruby    
ActiveMocker::LoadedMocks.delete_all
```
### ActiveRecord supported methods

See [Documentation](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker) for a complete list of methods and usage.

**Class Methods** - [docs](http://rdoc.info/github/zeisler/active_mocker/master/ActiveMocker/Mock/Base)

  * new
  * create/create!
  * column_names/attribute_names
  * delete_all/destroy_all
  * table_name
  
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
  * write_attribute/read_attribute - (protected, can be used within modules)
  * delete
  * new_record?
  * persisted?
  * reload
  * attribute_names
  * attribute_present?
  * has_attribute?

**has_one/belongs_to/has_many**

  * build_< association >
  * create_< association >
  * create_< association >!
  * < association >.create
  * < association >.build
  

### Schema/Migration Option Support
* All schema types are supported and coerced by [Virtus](https://github.com/solnic/virtus). If coercion fails the passed value will be retained.
* Default value is supported.
* Scale and Precision are not supported.

### Known Limitations
* Model names and table names must follow the default ActiveRecord naming pattern.
* When an association is set in one object it may not always be reflective in other objects, especially when it is a non standard/custom association. See [test_rails_4_app/spec/active_record_compatible_api.rb](https://github.com/zeisler/active_mocker/blob/master/test_rails_4_app/spec/active_record_compatible_api.rb) for a complete list of supported associations. 
* Validation/Callbacks are not supported.
* Sql queries, joins, etc will never be supported.
* A record that has been created and then is modified will persist changes without using calling `#save`, beware of this difference.

## Inspiration
Thanks to Jeff Olfert for being my original inspiration for this project.

## Contributing
Your contribution are welcome!

1. Fork it ( http://github.com/zeisler/active_mocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
