require 'app/models/book'
require 'app/models/import_log'

require 'app/helpers/library_file_system_helper'
require 'app/helpers/logging_helper'
require 'app/helpers/metadata_helper'

require 'app/jobs/refresh_metadata_job'

module EBL
  module Jobs
    # A background job that will scan a directory for ePub files
    # and process them into the EBookLibrary database.
    class EpubScanJob
      include SuckerPunch::Job
      include EBL::Helpers::LoggingHelper
      include EBL::Helpers::LibraryFileSystemHelper
      include EBL::Helpers::MetadataHelper

      # Save a book and its authors and add an entry to the import log.
      # @param book [EBL::Models::Book] the book to save.
      # @param type [Symbol] :epub or :pdf based on the book type.
      def save_book_and_import_log(book, type)
        begin
          book.save
        rescue Sequel::DatabaseError
          return nil
        end

        authors = []
        if type == :epub
          authors = extract_authors_from_epub(book.path)
        elsif type == :pdf
          authors == [extract_author_from_pdf_file(book.path)]
        end

        authors.each { |a| book.add_author(a) }
        EBL::Models::ImportLog.create(path: book.path, book_id: book.id)
      end

      # Create and save a new book in the database.
      # @param book_path [String] the path to the book to import.
      # @param type [Symbol] :pdf or :epub depending on the book type.
      # @return [EBL::Models::Book] the newly created book.
      def create_book(book_path, type)
        book = initialise_book(book_path, type)
        return nil if book.nil?

        if book.valid?
          return nil if save_book_and_import_log(book, type).nil?
          return book
        else
          log_error "Failed to validate book: #{book.errors.to_json}"
          return nil
        end
      end

      # Initialise a new book based on the file type.
      # @param book_path [String] the path to the book to initialise.
      # @param type [Symbol] :pdf or :epub depending on the book type.
      # @return [EBL::Models::Book] the book, or nil if an error occurs.
      def initialise_book(book_path, type)
        if type == :epub
          EBL::Models::Book.from_epub(book_path)
        elsif type == :pdf
          EBL::Models::Book.from_pdf(book_path)
        end
      end

      # Import the book into the database and queue a metadata refresh.
      # @param book_path [String] the path to the book to import.
      # @param type [Symbol] :pdf or :epub depending on the book type.
      def import_book(book_path, type)
        book = create_book(book_path, type)

        if book.nil? || !copy_book_to_library(book)
          log_error "Failed to import #{book_path}"
          return
        end

        log_green "Imported #{book.title} [ID:#{book.id}]"
        spawn_new_refresh_job book.id
      end

      # Process the specified path by queuing a scan job if it is
      # a directory or import it if it is an ePub file.
      # @param name [String] the file name, relative to #scan_path.
      def process_file(name)
        path = File.join(scan_path, name)

        if File.directory?(path)
          spawn_new_scan_job path
        elsif EBL::Models::ImportLog.imported?(path)
          return
        elsif epub?(path)
          import_book path, :epub
        elsif pdf?(path)
          import_book path, :pdf
        end
      end

      # Spawn a new scan job for the specified path.
      # @param path [String] the path to scan.
      def spawn_new_scan_job(path)
        if sync_refresh
          job = EpubScanJob.new
          job.sync_refresh = true
          job.perform(path)
        else
          EpubScanJob.perform_async(path)
        end
      end

      # Spawn a new job to refresh a book's metadata.
      # @param book_id [Integer] the ID of the book to refresh.
      def spawn_new_refresh_job(book_id)
        if sync_refresh
          EBL::Jobs::RefreshMetadataJob.new.perform(book_id, true)
        else
          EBL::Jobs::RefreshMetadataJob.perform_async(book_id, true)
        end
      end

      def perform(path)
        setup_logger 'job:scan'

        self.scan_path = File.expand_path(path)
        logger.log "Scanning #{scan_path}"

        Dir.new(scan_path).each do |file|
          next if dot_file?(file)
          process_file(file)
        end
      end

      attr_accessor :sync_refresh
      attr_accessor :scan_path
    end
  end
end
