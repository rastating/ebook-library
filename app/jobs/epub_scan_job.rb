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

      def save_book_and_import_log(book)
        book.save
        extract_authors_from_epub(book.path).each { |a| book.add_author(a) }
        EBL::Models::ImportLog.create(path: book.path, book_id: book.id)
      end

      # Create and save a new book in the database.
      # @param book_path [String] the path to the ePub file.
      # @return [EBL::Models::Book] the newly created book.
      def create_book(book_path)
        book = EBL::Models::Book.from_epub(book_path)

        if book.valid?
          save_book_and_import_log book
          return book
        else
          log_error "Failed to validate book: #{book.errors.to_json}"
          return nil
        end
      end

      # Import the book into the database and queue a metadata refresh.
      def import_book(book_path)
        book = create_book(book_path)

        if book.nil? || !copy_book_to_library(book)
          log_error "Failed to import #{book_path}"
          return
        end

        log_green "Imported #{book.title} [ID:#{book.id}]"
        EBL::Jobs::RefreshMetadataJob.perform_async(book.id, true)
      end

      # Process the specified path by queuing a scan job if it is
      # a directory or import it if it is an ePub file.
      # @param name [String] the file name, relative to #scan_path.
      def process_file(name)
        path = File.join(scan_path, name)

        if File.directory?(path)
          EpubScanJob.perform_async(path)
        elsif epub?(path) && !EBL::Models::ImportLog.imported?(path)
          import_book path
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

      attr_accessor :scan_path
    end
  end
end
