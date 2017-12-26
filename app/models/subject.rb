require 'app/models/book'

module EBL
  module Models
    # A subject / topic of a {Book}.
    class Subject < Sequel::Model
      plugin :validation_helpers

      many_to_one :book

      def validate
        super

        validates_max_length 100, :name
      end
    end
  end
end
