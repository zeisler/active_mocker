## Get started with railstutorial/sample_app_rails_4

Run the following commands in the console below:

1. `cd ~/workspace/sample_app_rails_4`
2. `cp config/database.yml.example config/database.yml`
3. `bundle install`
4. `bundle exec rake db:migrate`
5. `bundle exec rails server`

By clicking on Preview > Port 3000, you can now preview your sample
Rails App.

To check out more code, you can run tests, edit code and continue to
iterate on this application. To run the test suite, run the following
commands in the console:

1. `cd ~/workspace/sample_app_rails_4`
2. `bundle exec rake db:test:prepare`
3. `bundle exec rspec spec`
