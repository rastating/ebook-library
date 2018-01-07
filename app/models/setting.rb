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

      def self.create_or_update(key, value)
        setting = Setting.first(key: key)

        if setting.nil?
          Setting.create(key: key, value: value)
        else
          setting.value = value
          setting.save
        end

        setting
      end
    end
  end
end
