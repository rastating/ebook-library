require 'app/models/book'

module EBL
  module Models
    # An author of a {Book}.
    class Author < Sequel::Model
      plugin :validation_helpers

      many_to_one :book

      def validate
        super

        validates_max_length 500, :name
      end
    end
  end
end
