task rebuild_mocks: :environment do
  puts 'rebuilding mocks'
  ActiveMocker.create_mocks
end

['db:schema:load', 'db:migrate', 'db:reset'].each do |task|
  Rake::Task[task].enhance do
    Rake::Task['rebuild_mocks'].invoke
  end
end
