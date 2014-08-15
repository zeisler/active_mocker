# Changelog
All notable changes to this project will be documented in this file.
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