module EBL
  module Models
    # An application setting.
    class Setting < Sequel::Model
      plugin :validation_helpers

      def validate
        super

        validates_presence :key
        validates_max_length 50, :key
        validates_unique :key

        validates_presence :value
      end
    end
  end
end
