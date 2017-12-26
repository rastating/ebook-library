require 'app/models/book'

module EBL
  module Models
    # A log of a book import operation.
    class ImportLog < Sequel::Model
      plugin :validation_helpers

      one_to_one :book

      def validate
        super
        validates_presence :path
      end

      # Check if the file at the specified path has already been imported.
      # @param path [String] the path of the file to check.
      # @return [Boolean] true if the file has already been imported.
      def self.imported?(path)
        !ImportLog.find(path: path).nil?
      end
    end
  end
end
