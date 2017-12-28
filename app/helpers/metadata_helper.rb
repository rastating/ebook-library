require 'app/models/author'

module EBL
  module Helpers
    # A helper module containing methods for working with the metadata of books.
    module MetadataHelper
      # Extract the author list from the specified ePub file.
      # @param path [String] the path to the ePub file.
      # @return [Array] an array of {EBL::Models::Author}.
      def extract_authors_from_epub(path)
        epub = EPUBInfo.get(path)
        extract_authors_from_epubinfo(epub)
      end

      # Extract the author list from an {EPUBInfo}.
      # @param epub [EPUBInfo] the EPUBInfo instance to extract from.
      # @return [Array] an array of {EBL::Models::Author}.
      def extract_authors_from_epubinfo(epub)
        authors = []

        epub.creators.each do |c|
          author = EBL::Models::Author.first(name: c.name)
          author = EBL::Models::Author.new(name: c.name) if author.nil?

          already_added = authors.find { |a| a.name == c.name }
          authors.push(author) if already_added.nil?
        end

        authors
      end

      # Extract the date list from an {EPUBInfo}.
      # @param epub [EPUBInfo] the EPUBInfo instance to extract from.
      # @return [Array] an array of {EBL::Models::Date}.
      def extract_dates_from_epubinfo(epub)
        dates = []

        epub.dates.each do |d|
          next if d.date.nil?
          dates.push EBL::Models::Date.new(
            date: d.date,
            event: d.event
          )
        end

        dates
      end

      # Extract the identifier list from an {EPUBInfo}.
      # @param epub [EPUBInfo] the EPUBInfo instance to extract from.
      # @return [Array] an array of {EBL::Models::Identifier}.
      def extract_identifiers_from_epubinfo(epub)
        identifiers = []

        epub.identifiers.each do |i|
          identifiers.push EBL::Models::Identifier.new(
            identifier: i.identifier,
            scheme: i.scheme
          )
        end

        identifiers
      end

      # Extract the subject list from an {EPUBInfo}.
      # @param epub [EPUBInfo] the EPUBInfo instance to extract from.
      # @return [Array] an array of {EBL::Models::Subject}.
      def extract_subjects_from_epubinfo(epub)
        subjects = []

        epub.subjects.each do |s|
          subjects.push EBL::Models::Subject.new(name: s)
        end

        subjects
      end

      # Extract all usable metadata from an ePub file.
      # @param path [String] the path to the ePub file.
      # @return [Hash] a hash containing the metadata.
      def extract_metadata_from_epub(path)
        epub = EPUBInfo.get(path)
        {
          authors:      extract_authors_from_epubinfo(epub),
          dates:        extract_dates_from_epubinfo(epub),
          identifiers:  extract_identifiers_from_epubinfo(epub),
          subjects:     extract_subjects_from_epubinfo(epub)
        }
      end
    end
  end
end
