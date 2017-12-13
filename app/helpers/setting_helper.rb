module EBL
  module Helpers
    # A helper module containing methods for accessing service settings.
    module SettingHelper
      # Get a setting value.
      # @param name [String] the name of the setting.
      # @param default [String] the default value.
      # @return [String] the setting value, or if not found, the default value.
      def get_setting_value(name, default = nil)
        setting = EBL::Models::Setting.first(key: name)
        return default if setting.nil?
        setting.value
      end
    end
  end
end
