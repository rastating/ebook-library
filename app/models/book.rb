module EBL
  module Models
    # An object representing a book created from an ePub's metadata.
    class Book < Sequel::Model
      plugin :validation_helpers

      one_to_many :authors
      one_to_many :subjects
      one_to_many :identifiers
      one_to_many :dates

      def validate
        super

        validates_max_length 200, :title
        validates_max_length 500, :publisher, allow_nil: true
        validates_max_length 500, :rights, allow_nil: true
        validates_max_length 200, :source, allow_nil: true
        validates_max_length 10, :epub_version, allow_nil: true

        validates_presence :description
        validates_presence :drm_protected
      end
    end
  end
end
