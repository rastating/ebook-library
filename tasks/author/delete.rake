namespace :author do
  desc 'Delete an author by their ID number'
  task :delete, [:id] do |_t, args|
    require 'app/models/author'

    logger = EBL::Logger.new('author:delete')
    author = EBL::Models::Author.first(id: args[:id])

    if author.nil?
      logger.log "Author #{args[:id]} does not exist", :red
      next
    end

    author.remove_all_books
    author.destroy
    logger.log "Deleted author #{args[:id]}", :green
  end
end
