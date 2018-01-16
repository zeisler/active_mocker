# Changelog
All notable changes to this project will be documented in this file.

## Current
### Enhancement
- Locally defined modules are imported and included.

## 2.6.0 - 2017-12-01
### Feature
- Relation#order now accepts all non-SQL arguments

Example usage:
```ruby
  User.order('name')

  User.order(:name)

  User.order(email: :desc)

  User.order(:name, email: :desc)
  
  User.order(name: :desc, email: :asc)
```

### Enhancement
- Improved output for `rake active_mocker:build`. When all mocks built successfully the messaging could be misleading. 
- Error message for calling stubbed methods better formats RSpec syntax for variable names.
- Now whitelist all locally defined methods as safe to copy/run within mock 
```ruby
# ActiveMocker.all_methods_safe
class User < ActiveRecord::Base
end
```

OR blacklist methods from being safe.

```ruby
# ActiveMocker.all_methods_safe except: { instance_methods: [], class_methods: [], scopes: [] }
class User < ActiveRecord::Base
end
```

## 2.5.4 - 2017-11-17
### Fix
- has_and_belongs_to_many association did not contain scoped methods.

### Enhancement
- Error message when calling stubbed methods show safe_methods syntax along with RSpec syntax.

## 2.5.3 - 2017-10-01
### Fix
- Update gem dependency to fix Macro `ActiveMocker.safe_methods` when marking class_methods.

## 2.5.2 - 2017-09-29
### Feature
- Add mockable class methods to relations.
- In ActiveRecord model comment Macro `ActiveMocker.safe_methods` now allow class_methods 
```ruby
ActiveMocker.safe_methods(*instance_methods, scopes: [], instance_methods: [], class_methods: [])
```

### Enhancement
- Better error message when calling mockable method. Shows RSpec syntax to stub method.
```ruby     
    Unknown implementation for mock method: UserMock.new_remember_token
    Stub method to continue.
    
    RSpec:
    allow(
      UserMock
    ).to receive(:new_remember_token).and_return(:some_expected_result)
```

### Removed
- `ActiveMocker::MockAbilities` required by "active_mocker/deprecated_components/mock_abilities"
- `mock_method('ClassName')` required by "active_mocker/deprecated_components/rspec" Use `active_mocker.mocks.find('ClassName')` instead

## 2.5.1 - 2017-07-21
### Feature
- Support ActiveRecord v5.1 when generating under that version delete_all does not accept any arguments.

## 2.5.0 - 2017-03-17
### Feature
- In comment Macro `ActiveMocker.safe_methods(*instance_methods, scopes: [], instance_methods: [])` Now accepts scope methods

## 2.4.4 - 2017-03-10
### Fix
- Really fix: scope methods returned `undefined method `call_mock_method' for nil:NilClass` for Mocks nested in modules. 

## 2.4.3 - 2017-03-10
### Fix
- scope methods returned `undefined method `call_mock_method' for nil:NilClass` for Mocks nested in modules. 

## 2.4.2 - 2017-01-11
### Enhancement
- Semantically version mock generation separately.

## 2.4.1 - 2017-01-11
### Fix
- When a type was an Array state could be shared between records.

## 2.4.0 - 2016-12-14

### Enhancement
- Whitelist methods to import into mock code by adding a comment with `ActiveMocker.safe_methods(*methods)`
```ruby
# ActiveMocker.safe_methods :full_name
class User < ActiveRecord::Base
  def full_name
    "#{last_name}, #{first_name}"
  end
end
```

## 2.4.0.pre3 - 2016-10-18
### Fix
- Add missing requires

## 2.4.0.pre2 - 2016-10-17
### Enhancement
- ActiveRecord Enum support
Compatible with ActiveRecord versions 5 and 4. Generating using different version of ActiveRecord creates different mock files.

## 2.4.0.pre1 - 2016-10-13
### Enhancement
- Option to delete all records before each example
    It can be enabled for specific test context.
    ```ruby
    before(:all) { active_mocker.features.enable(:delete_all_before_example) }
    after(:all) { active_mocker.features.disable(:delete_all_before_example) }
    ```
    
    Or it can be enabled as the default
    
    ```ruby
    ActiveMocker::LoadedMocks.features.enable(:delete_all_before_example)
    ```

- Option to enable timestamps

    ```ruby
    ActiveMocker::LoadedMocks.features.enable(:timestamps)
    ```

## 2.3.4 - 2016-10-21
### Fix
- Passing a single record when to collection association now causes a failure. 

## 2.3.3 - 2016-10-13
### Enhancement
-  Auto stubbing of ActiveRecord::RecordNotFound with requiring "active_mocker/rspec_helper"

### Fix 
- NoMethodError when calling #find_by! on an association when the record could not be found.

## 2.3.2 - 2016-09-26
### Fix
- Fix case where parent class was not being set and set was set to `ActiveMocker::Base`.
- Stop generating Mocks when table cannot be found.

## 2.3.1 - 2016-09-26
### Fix
- `create_<association>` failed to set the foreign key.

### Enhancement
- Specific ActiveMocker exceptions now all inherit from `ActiveMocker::BaseError`

## 2.3.0 - 2016-08-29
### Feature
- Added `#first_or_create`, `#first_or_create!`, and `#first_or_initialize`

### Enhancement
- Improved API for registering unknown types and defaults. See https://github.com/zeisler/active_record_schema_scrapper#registering-types

### Deprecation
- `ActiveRecordSchemaScrapper::Attributes.register_default` gives a deprecation warning if given keys :name and :klass.
New names are :default and :replacement_default.

Example usage:
```ruby
ActiveRecordSchemaScrapper::Attributes.register_default(
  default:             "{}", 
  replacement_default: [], 
  cast_type:           -> (c) { c.class.name.include?("Array") } 
)
```
https://github.com/zeisler/active_record_schema_scrapper/blob/master/lib/active_record_schema_scrapper/attributes.rb#L36

## 2.2.5 - 2016-08-28
### Fix
- Ensure '#update' calls save. Addressing the case where an object had not been saved prior would not get persisted.

### Enhancement
- Add documentation to `#assign_attributes`

## 2.2.4 - 2016-08-13
### Fix
- `BigDecimal`, `Date`, `DateTime`, and `Time` when used as defaults in the schema caused mock generation failures.

## 2.2.3 - 2016-06-27
### Fix
- Constant values assigned to non sudo primitives objects causing issues. https://github.com/zeisler/active_mocker/issues/72

### Enhancement
- Tested support for Rails RC2

## 2.2.2 - 2016-05-05
### Fix
- When using "active_mocker/rspec_helper" with active_mocker:true tag, subclassed mocks were not getting auto stubbed.
- colorize gem was not being required.

## 2.2.1 - 2016-05-03
### Fix
- Remove hack for String#colorize that would cause the error: "NoMethodError: super: no superclass method `colorize' for #<String>"

## 2.2.0 - 2016-05-03
### Feature 
- Add `ActiveMocker::Mock#slice`
- Import alias_attribute usage to mock  - With supporting methods `attribute_alias?(name)` and `attribute_alias(name)`

### Fix
- When an include/extended module is not locally defined, but defined in the same namespace as the mock it was not correctly namespaced
- Fix issue NoMethodError in Rails 5.beta when introspection activerecord model.

### Enhancement
-  Ignore all non ActiveRecord::Base subclasses
- Make rake dependency less strict `>= 10.0`

## 2.1.3 - 2016-03-21
### Fix
- Issue where namespaced mocks would not be auto stubbed. 

## 2.1.2 - 2016-03-14
### Fix
-  When method or scopes defined on the model took an explicit block ie. `&block` it would cause an error.

## 2.1.1 - 2016-02-12
### Fix
- Mocks persist after model is deleted - https://github.com/zeisler/active_mocker/issues/35

## 2.1.0 - 2016-02-05
### Enhancement
- Support for module nested models.
- Adding support for ruby 2.3

## 2.0.0 - 2015-12-22
### Enhancement
- The mock append name is now changeable using `ActiveMocker::Config.mock_append_name=`. The default still being `Mock`.
- `ActiveMocker::MockRelation(mock, collection)` to create separate independent mock collections.
- Change `ActiveMocker::Mock::Base` to `ActiveMocker::Base`
- Provide more control over error when running `rake active_mocker:build`, error_verbosity now has setting for 0 to 3.
- `db/schema.rb` is no longer required to generate mocks.
- Much better support for Single Table Inheritance and gems that add functionality by being the parent class of model.
- New DB types can be registered with this API. `ActiveRecordSchemaScrapper::Attribute.register_type(name: :array, klass: Array)`
- `ActiveMocker::Config.disable_modules_and_constants=` Non locally defined Modules are included/extended by default as well as constant declarations. To Disable to feature set to `true`.
- `MODEL=User rake active_mocker:build` no longer takes a model name to generate just that mock. It now takes a path to a model file. `MODEL=[path-to-model] rake active_mocker:build`
- When running `rake active_mocker:build` failed will be listed.

### Fix
- Reduce restriction on Virtus gem to 1.0.any
- When id is not a fixnum and make it match ActiveRecord behavior of calling `#to_i`.

### Deprecated
- Moved `ActiveMocker::MockAbilities` into "active_mocker/deprecated_components/mock_abilities" if a project is still dependent on it this file it can be required and used at least until version 3.0. The alternative is to use `RSpec` verified doubles.
- `#mock_class("Mock")` method has been moved to "active_mocker/deprecated_components/rspec_helper" if a project is still dependent on it this file it can be required and used at least until version 3.0. The alternative is to use the new api that is accessible by instead `active_mocker.mocks.find('ClassName')`.

### Removed
- `log/active_mocker.log` is replaced env `ERROR_VERBOSITY=[0,1,2,3] rake active_mocker:build` or in Ruby `ActiveMocker::Config.error_verbosity=`
- Removing undocumented feature of treating children of mocks differently. Remove the ability to sub class a mock and have it for use in that context when creating/finding association.

## 1.8.4 - 2015-10-06
### Fix
- Calling scoped method that has not been stubbed raises incorrect error. https://github.com/zeisler/active_mocker/issues/22
- Not closing file stream while writing mocks. https://github.com/zeisler/active_mocker/pull/29

## 1.8.3 - 2015-03-03
### Fix
- When AR model ended in 's' it would result in failing to create the mock file.

## 1.8.2 - 2015-03-01
### Fix
- **Very critical issue**. In rare cases running `rake active_mocker:build` could delete you entire hard drive. When mock_dir is nil or “” it would rm_rf the entire drive. This has been fixed by raising an error if mock_dir is not set. Also, it will never delete any directories, only files that match `*_mock.rb`. Highly recommended that everyone update.

## 1.8.1
### Enhancement
- Reduce Ruby version requirement from 2.1.5 to => 2.1

## 1.8 - 2015-02-17

### Notes
This release has minor speed improvements. You may find that some records where an attribute was nil it will now have an a value. Next release will most likely be 2.0 where I will focus on removing deprecated features and performance of the mocks runtime.

### Enhancement
- Improve accuracy and speed in some cases, for finding associations by not assigning them at creation time but finding them when called.
- Hide the internals stack trace when calling method that will raising `NotImplementedError`.
- Add spec documentation for method #new_relation

### Added
- Support for ruby 2.2.0 and rails 4.2
- new method #none does what it does for ActiveRecord

## 1.7.3 - 2014-12-01

### Fix
- Passing nil to `find` should of raised an error.

## 1.7.2 - 2014-10-27

### Enhancement
- Build command can take aa Environment variable of model to just generate a mock for a specific model. `rake active_mocker:build MODEL=user` 
- Add Method #freeze, see Doc for limitation.
- Method `find` can take a string number or an array of string numbers
- Query #all can take take method []

## 1.7.1 - 2014-10-20

### Enhancement
- Now works with Rails versions: 4.0, 4.1, 4.2beta2.

### Fix
- Issue when a relation had a scope defined by proc it would fail.

## 1.7 - 2014-10-14

### Enhancement
- Now will regenerate mock after `rake db:rollback`.
- Check added to see if mock was created with same running gem version of ActiveMocker. If they are not the same it will raise an error informing you to run `rake active_mocker:build`.
- belong_to and has_one relationships when assigned will in most cases assign it's self to the corresponding has_many or like association. See `test_rails_4_app/spec/active_record_compatible_api.rb` for supported detail of supported ActiveRecord features.
- A class that Inherits a model now has the table of the parent.
- Use this option if you need to modify where the mock generation hooks into. `ActiveMocker::Config.model_base_classes = %w[ ActiveRecord::Base ]`
- When running `rake active_mocker:build` it will display the number of mocks that failed.
- Exceptions in mock generation no longer halt the rest of the mocks from generating.
- Add explicit message of what to do when a method is unimplemented.
- Will create own log file `log/active_mocker.log` it will be cleared on each generation.
- Attributes, associations, and scopes will now inherit from their parent class.

### Removed
- `ActiveMocker::Mock::Config.experimental` flag has been removed, these are now on by default.
- Remove deprecated option `ActiveMocker.mock`
- Remove Experimental feature reload
- Remove experimental flag for set foreign_key on collection for has_many, belongs_to, and has_one.

## Added
- Class method `table_name`.
- Initialization of an abstract class will raise an error.
- `record._create_caller_locations` for debugging obj’s creation location.

### Fix
- Last beta introduced a bug where after assigning some associations they could not be read. Solution was to never access @associations directly inside mock. 
- Bug where creating record with an id could cause a duplicate id error.
- Issue whenever an ActiveRecord Model has no schema behind it.
- Issue assigning association would fail, added guard to @associations to only read and write symbols.
- Issue where using table names as the model file would replace a parent class with a child class that had the same table.

## 1.6.3 - 2014-08-14

### Fix
- Remove check for object is defined and then deleting, it is no longer needed there are better ways to manage clearing state.
- `rake active_mock:build` failed parsing when an ActiveRecord Model had no table, example where `self.abstract_class = true` was set.
- `rake active_mock:build` failed for STI models.

###Enhancement
- Removing methods `#hash` and `==` and using Ruby defaults gives modest performance improvements.
- Cache build_types object for small performance improvements. 

## 1.6.2 - 2014-07-31

## Fix 
- Ruby interpreter warnings
- calling `#blank?` inside of `Base#assign_attributes` would get a no method error. Solution is to require ‘active_support/core_ext’ in mock.rb.

## 1.6.1 - 2014-07-30

### Fix
- In `experimental` features where variable name should of been a symbol.
### Enhancement
- `experimental` features: When assigning an association the record being associated will now try to either assign a has_many or has_one association onto the inputted record.

## 1.6 - 2014-07-29

### Enhancement
- When calling limit and then delete_all will raises an ActiveMocker error:
- When mass assignment an unknown attribute the error message will mirror ActiveRecord.
- `where` can now accept a range instead of just an array as a value.
- `update` can update multiple records.
- `delete` can take an array or an integer
- `find` will now raise RecordNotFound
- `count` can now take an attribute name and will return the total count of records where the attribute is present.
- `create` now supports creating multiple records at once.

### Added
- Added documentation for many methods.
- find_or_create_by/find_or_initialize_by now accessible from any collection.
- Instance methods `attribute_names`, `attribute_present?`, `has_attribute?`
- Using `ActiveMocker::Mock.config.experimental = true`. This will turn on features that are not complete and may not work as expected, especially if you have complex relationships. This will activate the following features:
    - When passing in collection all item in collection will set its foreign key to the parent.
    - When setting association by object it will set the child association.

### Fixed
- `new_record?` would return the opposite of the truth.
- Remove method `to_hash` because it is unsupported in ActiveRecord.
- Requiring `active_mocker/rspec_helper` will now require loaded_mocks class. If no mocks were required the constant lookup would fails.
- When a model is deleted the mock file will not linger and letting tests pass.

## 1.5.2 - 2014-07-14

### Fixed
- `rake active_mocker:build` will only run after `rake db:migrate` instead of `db:schema:load` and `db:reset`.
- Removed Unused folder lib/active_record

## 1.5.1 - 2014-07-08

### Fixed
- Fix Queriable#sum to default to zero when value is nil
- Remove rspec_helper.rb from mock.rb.

## 1.5 - 2014-07-07

### Added
- Modules that are included/extended in ActiveRecord Models are now available. This may cause failing tests, requiring the modules will fix the issues. 
- Scoped methods from association will be available if the associated mock is loaded.
- rspec_helper.rb
  - Using `tag active_mocker:true` will stub ActiveRecord Model constants for Mock constants. To use with `before(:all)` wrap Constant in `#mock_class('ClassName')`. Using all AR Model names will allow a spec file to run as a full Rails test and as a unit test. 
  - Tag will also clear all mocks after(:all)
  
### Deprecated
- mock_class_method and mock_instance_method are deprecated and will be removed in 2.0. Rspec 3 mocks has a better implantation of this feature.

### Removed
- Nothing.

### Fixed
- `has_many#create_assocation` will now correctly add it self to the parent record.
