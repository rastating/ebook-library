module EBL
  module Models
    # A {Book} identifier.
    class Identifier < Sequel::Model
      plugin :validation_helpers

      many_to_one :book

      def validate
        super

        validates_max_length 100, :identifier
        validates_max_length 50, :scheme, allow_nil: true
      end
    end
  end
end
