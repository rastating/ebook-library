namespace :author do
  desc 'Merge all books from [src_id] to [dest_id]'
  task :merge, [:src_id, :dest_id] do |_t, args|
    require 'app/models/author'
    require 'readline'
    require 'lib/ebl/logger'

    logger = EBL::Logger.new('author:merge')

    source = EBL::Models::Author.first(id: args[:src_id])
    dest = EBL::Models::Author.first(id: args[:dest_id])

    if source.nil?
      logger.log "Could not find author with ID #{args[:src_id]}", :red
      next
    end

    if dest.nil?
      logger.log "Could not find author with ID #{args[:dest_id]}", :red
      next
    end

    prompt = "Are you sure you want to move all books from #{source.name.red.bold} to #{dest.name.red.bold}? [Y/n]: "
    confirmed = Readline.readline(prompt).casecmp('y').zero?
    next unless confirmed

    books = source.books
    books.each do |book|
      dest.add_book(book)
      logger.log "Merged #{book.id}: #{book.title}"
    end

    source.remove_all_books
    logger.log 'Merge complete!', :green
  end
end
