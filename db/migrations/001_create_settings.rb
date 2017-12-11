Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: settings'
    create_table :settings do
      primary_key :id
      column :key, :string, size: 50, null: false, unique: true
      column :value, :text, null: false
    end
  end

  down do
    logger.log 'Dropping table: settings'
    drop_table :settings
  end
end
