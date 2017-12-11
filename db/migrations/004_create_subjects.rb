Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: subjects'
    create_table :subjects do
      primary_key :id
      foreign_key :book_id, :books
      column :name, :string, size: 100, null: false
    end
  end

  down do
    logger.log 'Dropping table: subjects'
    drop_table :subjects
  end
end
