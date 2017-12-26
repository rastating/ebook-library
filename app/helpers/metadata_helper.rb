require 'app/models/author'

module EBL
  module Helpers
    # A helper module containing methods for working with the metadata of books.
    module MetadataHelper
      # Extract the author list from the specified ePub file.
      # @param path [String] the path to the ePub file.
      # @return [Array] an array of {EBL::Models::Author}.
      def extract_authors_from_epub(path)
        authors = []

        epub = EPUBInfo.get(path)
        epub.creators.each do |c|
          authors.push EBL::Models::Author.new(name: c.name)
        end

        authors
      end
    end
  end
end
