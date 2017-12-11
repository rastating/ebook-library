Sequel.migration do
  logger = EBL::Logger.new
  logger.context = 'db:migrate'

  up do
    logger.log 'Creating table: books'
    create_table :books do
      primary_key :id
      column :title, :string, size: 200, null: false
      column :description, :text, null: false
      column :publisher, :string, size: 500
      column :drm_protected, :boolean, null: false
      column :cover_path, :text
      column :epub_version, :string, size: 10
      column :rights, :string, size: 500
      column :source, :string, size: 200
    end
  end

  down do
    logger.log 'Dropping table: books'
    drop_table :books
  end
end
