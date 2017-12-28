require 'app/models/book'
require 'app/models/book_author'

module EBL
  module Models
    # An author of a {Book}.
    class Author < Sequel::Model
      plugin :validation_helpers

      many_to_many :books, join_table: :book_authors

      def validate
        super

        validates_max_length 500, :name
        validates_unique :name
      end
    end
  end
end
