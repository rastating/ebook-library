Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: import_logs'
    create_table :import_logs do
      primary_key :id
      foreign_key :book_id, :books
      column :path, :text, null: false
    end
  end

  down do
    logger.log 'Dropping table: import_logs'
    drop_table :import_log
  end
end
