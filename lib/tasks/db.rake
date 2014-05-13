# http://blog.nathanhumbert.com/2010/02/rails-3-loading-rake-tasks-from-gem.html

['db:schema:load', 'db:migrate', 'db:reset'].each do |task|
  Rake::Task[task].enhance do
    Rake::Task['rebuild_mocks'].invoke
  end
end

task rebuild_mocks: :environment do
  puts 'rebuilding mocks'
end