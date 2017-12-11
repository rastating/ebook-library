Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: dates'
    create_table :dates do
      primary_key :id
      foreign_key :book_id, :books
      column :date, :datetime, null: false
      column :event, :string, size: 50
    end
  end

  down do
    logger.log 'Dropping table: dates'
    drop_table :dates
  end
end
