Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: users'
    create_table :users do
      primary_key :id
      column :username, :string, length: 50, null: false, unique: true
      column :password, :string, length: 100, null: false
      column :locked, :boolean, default: false
    end
  end

  down do
    logger.log 'Dropping table: users'
    drop_table :users
  end
end
