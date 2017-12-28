Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: authors'
    create_table :authors do
      primary_key :id
      column :name, :string, size: 500, unique: true, null: false
    end

    logger.log 'Creating table: book_authors'
    create_table :book_authors do
      primary_key :id
      foreign_key :book_id, :books
      foreign_key :author_id, :authors
    end
  end

  down do
    logger.log 'Dropping table: authors'
    drop_table :authors

    logger.log 'Dropping table: book_authors'
    drop_table :book_authors
  end
end
