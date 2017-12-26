require 'app/helpers/setting_helper'

module EBL
  module Helpers
    # A helper module containing methods for handling book cover related tasks.
    module CoverHelper
      include EBL::Helpers::SettingHelper

      # @return [String] the directory which cover images are stored in.
      def covers_directory_path
        path = get_setting_value('covers_path')
        return path unless path.nil?

        base_path = File.expand_path('../../', __dir__)
        File.join(base_path, 'public', 'assets', 'images', 'covers')
      end

      # Save a cover from an ePub to disk.
      # @param book [EBL::Models::Book] the book to associate the cover with.
      # @param cover [EPubInfo::Models::Cover] the cover to process.
      # @return [String] the filename the cover was stored as.
      def save_cover_to_disk(book, cover)
        base = covers_directory_path
        filename = "#{book.id}_#{cover.original_file_name}"

        cover.tempfile do |file|
          FileUtils.cp file.path, File.join(base, filename)
        end

        filename
      end
    end
  end
end
