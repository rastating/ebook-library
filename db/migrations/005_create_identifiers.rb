Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: identifiers'
    create_table :identifiers do
      primary_key :id
      foreign_key :book_id, :books
      column :identifier, :string, size: 100, null: false
      column :scheme, :string, size: 50
    end
  end

  down do
    logger.log 'Dropping table: identifiers'
    drop_table :identifiers
  end
end
