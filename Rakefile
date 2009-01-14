require "rake/testtask"
require "rcov/rcovtask"

desc "Run all tests and check test coverage"
task :default => "test:coverage:verify"

desc "Run tests"
task :test => %w(test:units test:acceptance)

namespace :test do
  Rake::TestTask.new(:units) do |t|
    t.libs = ['lib']
    t.test_files = FileList["test/unit/*_test.rb"]
  end

  Rake::TestTask.new(:acceptance) do |t|
    t.libs = ['lib']
    t.test_files = FileList["test/acceptance/*_test.rb"]
  end
  
  desc "Measure test coverage"
  task :coverage => %w(test:coverage:units test:coverage:acceptance)
  
  namespace :coverage do
    desc "Measure test coverage of unit tests"
    Rcov::RcovTask.new(:units) do |rcov|
      rcov.pattern   = "test/unit/*_test.rb"
      rcov.rcov_opts = %w(--html --aggregate .aggregated_coverage_report)
      rcov.rcov_opts << ENV["RCOV_OPTS"] if ENV["RCOV_OPTS"]
    end
    
    desc "Measure test coverage of acceptance tests"
    Rcov::RcovTask.new(:acceptance) do |rcov|
      rcov.pattern   = "test/acceptance/*_test.rb"
      rcov.rcov_opts = %w(--html --aggregate .aggregated_coverage_report)
      rcov.rcov_opts << ENV["RCOV_OPTS"] if ENV["RCOV_OPTS"]
    end
    
    desc "Verify test coverage"
    task :verify => "test:coverage" do
      File.read("coverage/index.html") =~ /<tt class='coverage_total'>\s*(\d+\.\d+)%\s*<\/tt>/
      coverage = $1.to_f
      
      puts
      if coverage == 100
        puts "\e[32m100% coverage! Awesome!\e[0m"
      else
        puts "\e[31mOnly #{coverage}% code coverage. You can do better ;)\e[0m"
      end
    end
  end
end

task :environment do
  $:.unshift "#{File.dirname(__FILE__)}/lib"
  require 'integrity'
end

namespace :db do
  desc "Setup connection."
  task :connect => :environment do
    if ENV['CONFIG']
      config = File.expand_path(ENV['CONFIG'])
    elsif config_file = Integrity.root / 'config' / 'config.yml' and File.exists?(config_file)
      config = config_file
    else
      config = nil
    end
    Integrity.new(config)
  end

  desc "Automigrate the database"
  task :migrate => :connect do
    require "integrity/project"
    require "integrity/build"
    require "integrity/notifier"
    DataMapper.auto_migrate!
  end
end

begin
  require 'jeweler'
rescue LoadError
  # you must install jeweler for gem-related tasks
else
  Jeweler::Tasks.new do |s|
    file_list = FileList.new `git ls-files`.split("\n").reject { |f| f =~ %r{^(\.git|test/)} }
    file_list.exclude('vendor/webrat')
    file_list.include('vendor/sinatra/lib/**/*', 'vendor/sinatra-diddies/lib/**/*')
    file_list.include('vendor/rack-contrib/lib/**/*')

    s.name                 = 'integrity'
    s.summary              = 'The easy and fun Continuous Integration server'
    s.description          = 'Your Friendly Continuous Integration server. Easy, fun and painless!'
    s.homepage             = 'http://integrityapp.com'
    s.rubyforge_project    = 'integrity'
    s.email                = 'contacto@nicolassanguinetti.info'
    s.authors              = ['Nicolás Sanguinetti', 'Simon Rozet']
    s.files                = file_list
    s.executables          = ['integrity']
    s.post_install_message = 'Run `integrity help` for information on how to setup Integrity.'

    s.add_dependency 'haml' # ah, you evil monkey you
    s.add_dependency 'dm-core', ['>= 0.9.5']
    s.add_dependency 'dm-validations', ['>= 0.9.5']
    s.add_dependency 'dm-types', ['>= 0.9.5']
    s.add_dependency 'dm-timestamps', ['>= 0.9.5']
    s.add_dependency 'dm-aggregates', ['>= 0.9.5']
    s.add_dependency 'data_objects', ['>= 0.9.5']
    s.add_dependency 'do_sqlite3', ['>= 0.9.5']        
    s.add_dependency 'json'
    s.add_dependency 'thor'
    s.add_dependency 'bcrypt-ruby'
  end
end
