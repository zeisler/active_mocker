['db:schema:load', 'db:migrate', 'db:reset'].each do |task|
  Rake::Task[task].enhance do
    Rake::Task['rebuild_mocks'].invoke
  end
end

task rebuild_mocks: :environment do
  puts 'rebuilding mocks'
  ActiveMocker::Generate.new
end