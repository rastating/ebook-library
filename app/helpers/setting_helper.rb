require 'app/models/setting'

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

      # @return [String] the path where books are stored.
      def library_path
        get_setting_value('library_path')
      end

      # @return [String] the path to the folder which should
      #   be monitored for new books.
      def watch_folder_path
        get_setting_value('watch_folder')
      end
    end
  end
end
