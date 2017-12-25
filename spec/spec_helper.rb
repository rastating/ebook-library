ENV['RACK_ENV'] = 'test'
$VERBOSE = nil

require_relative '../env'

require_relative '../app/models/book'
require_relative '../app/models/author'
require_relative '../app/models/subject'
require_relative '../app/models/identifier'
require_relative '../app/models/date'
require_relative '../app/models/setting'
require_relative '../app/models/import_log'

require_relative '../app/helpers/setting_helper'
require_relative '../app/helpers/cover_helper'

require 'rack/test'
require 'rspec'
require 'rspec_sequel_matchers'
require 'database_cleaner'

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
