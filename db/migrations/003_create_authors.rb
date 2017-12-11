Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: authors'
    create_table :authors do
      primary_key :id
      foreign_key :book_id, :books
      column :name, :string, size: 500
    end
  end

  down do
    logger.log 'Dropping table: authors'
    drop_table :authors
  end
end
