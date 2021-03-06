require 'app/helpers/setting_helper'

module EBL
  module Helpers
    # A helper module containing methods for accessing and
    # manipulating the library file system.
    module LibraryFileSystemHelper
      include SettingHelper

      # @return [Boolean] true if the filename is ".", or ".."
      def dot_file?(filename)
        %w[. ..].include? filename
      end

      # @return [Boolean] true if the file extension is epub.
      def epub?(filename)
        File.extname(filename).casecmp('.epub').zero?
      end

      # @return [Boolean] true if the file extension is pdf.
      def pdf?(filename)
        File.extname(filename).casecmp('.pdf').zero?
      end

      # Create a normalised name, suitable for the file system.
      # @param name [String] the name to normalise.
      # @return [String] returns the name with bad characters removed.
      def safe_name(name)
        name.gsub(/[^0-9A-Za-z\-]/, '_')
      end

      # Create a copy of the ePub file associated with the
      # {EBL::Models::Book} specified, and update the model.
      # @param book [EBL::Models::Book] the book to copy.
      # @return [Boolean] true if the operation is successful.
      def copy_book_to_library(book, remove_src = false)
        author_path = File.join(library_path, safe_name(book.primary_author))
        FileUtils.mkdir_p author_path

        src_path = book.path
        book_filename = "#{book.id}_#{safe_name(book.title)}#{File.extname(src_path)}"
        dest_path = File.join(author_path, book_filename)
        FileUtils.cp src_path, dest_path

        return false unless File.exist?(dest_path)
        book.update_path_and_refresh_checksum(dest_path, true)

        FileUtils.rm src_path if remove_src
        true
      end

      # Check if a book's checksum has changed since it was last updated.
      # @param book [EBL::Models::Book] the book to check.
      # @return [Boolean] true if the file on disk has changed.
      def checksum_changed?(book)
        data = File.read(path)
        md5 = Digest::MD5.new
        md5 << data

        book.checksum != md5
      end
    end
  end
end
