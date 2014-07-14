# Changelog
All notable changes to this project will be documented in this file.

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