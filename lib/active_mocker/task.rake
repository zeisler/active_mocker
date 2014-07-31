namespace :active_mocker do

  desc('Rebuild mocks.')
  task :build => :environment do
    ActiveMocker::Generate.new
  end

  desc('Run all tests tagged   active_mocker')
  task :test do
    sh 'rspec --tag active_mocker'
  end

  desc('Run all tests tagged active_mocker and rails_compatible and will disable model stubbing')
  task :rails_compatible do
    sh 'RUN_WITH_RAILS=1 rspec --tag rails_compatible'
  end

end

['db:migrate'].each do |task|
  Rake::Task[task].enhance do
    Rake::Task['active_mocker:build'].invoke
  end
end


