# Changelog
All notable changes to this project will be documented in this file.

## 1.7.1rc - 2014-10-19

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