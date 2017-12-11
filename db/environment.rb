ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']

db_config_path = File.join('db', 'config.yml')
db_config = YAML.load_file(db_config_path)[ENV['RACK_ENV']]

Sequel::Model.plugin :timestamps
Sequel::Model.db = Sequel.connect(db_config)
