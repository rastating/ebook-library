require 'app/models/author'
require 'app/models/book_author'
require 'app/models/subject'
require 'app/models/identifier'
require 'app/models/date'

module EBL
  module Models
    # An object representing a book created from an ePub's metadata.
    class Book < Sequel::Model
      plugin :validation_helpers

      many_to_many :authors, join_table: :book_authors

      one_to_many :subjects
      one_to_many :identifiers
      one_to_many :dates

      def validate
        super

        validates_max_length 200, :title
        validates_max_length 500, :publisher, allow_nil: true
        validates_max_length 500, :rights, allow_nil: true
        validates_max_length 200, :source, allow_nil: true
        validates_max_length 100, :checksum, allow_nil: true

        # validates_max_length bugs if it sees what it thinks is an integer.
        # use validates_format to work around this in this instance, as
        # epub_version is typically going to be an integer / float value.
        validates_format(/^.{1,10}$/, :epub_version) unless epub_version.nil?

        validates_presence :description
        validates_presence :drm_protected
        validates_presence :path
      end

      # @return [String] the name of the first author, or "Unknown"
      def primary_author
        return 'Unknown' if authors.empty? || authors[0].name.empty?
        authors[0].name
      end

      # Recalculate the checksum of the file stored at #path.
      def refresh_checksum
        if path.nil? || path.empty? || !File.exist?(path)
          self.checksum = ''
          return
        end

        data = File.read(path)
        md5 = Digest::MD5.new
        md5 << data
        self.checksum = md5.hexdigest
      end

      # Set the path value and refresh the checksum value.
      # @param path [String] the path to the ePub.
      # @param should_save [Boolean] flag indicating whether to also
      #   make a call to #save.
      def update_path_and_refresh_checksum(path, should_save = false)
        self.path = path
        refresh_checksum
        save if should_save
      end

      # Parse an ePub file into an {EBL::Models::Book}.
      # @param path [String] the path to the ePub file to parse.
      # @return [EBL::Models::Book] a book model based on the
      #   metadata of an ePub file.
      def self.from_epub(path)
        epub = EPUBInfo.get(path)
        book = EBL::Models::Book.new
        book.title = epub.titles[0]

        book.description = 'This book has no description'
        if !epub.description.nil? && !epub.description.empty?
          book.description = epub.description
        end

        book.drm_protected = epub.drm_protected
        book.epub_version = epub.version.to_s
        book.update_path_and_refresh_checksum(path)
        book
      end
    end
  end
end
