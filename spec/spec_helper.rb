ENV['RACK_ENV'] = 'test'
$VERBOSE = nil

require_relative '../env'

require 'rake'
require 'rack/test'
require 'rspec'
require 'rspec_sequel_matchers'
require 'database_cleaner'
require 'sucker_punch/testing/inline'

load 'tasks/db/migrate.rake'
Rake::Task['db:migrate'].execute

DatabaseCleaner[:sequel].db = Sequel::Model.db

RSpec.configure do |config|
  config.include RspecSequel::Matchers
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
