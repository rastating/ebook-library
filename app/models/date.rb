module EBL
  module Models
    # A date associated with a {Book}.
    class Date < Sequel::Model
      plugin :validation_helpers

      many_to_one :book

      def validate
        super

        validates_presence :date
        validates_max_length 50, :event, allow_nil: true
      end
    end
  end
end
