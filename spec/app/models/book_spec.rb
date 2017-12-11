require_relative '../../spec_helper'

describe EBL::Models::Book, type: :model do
  it { is_expected.to have_one_to_many :authors }
  it { is_expected.to have_one_to_many :subjects }
  it { is_expected.to have_one_to_many :identifiers }
  it { is_expected.to have_one_to_many :dates }

  it { is_expected.to validate_max_length 200, :title }
  it { is_expected.to validate_max_length 500, :publisher, allow_nil: true }
  it { is_expected.to validate_max_length 500, :rights, allow_nil: true }
  it { is_expected.to validate_max_length 200, :source, allow_nil: true }
  it { is_expected.to validate_max_length 10, :epub_version, allow_nil: true }

  it { is_expected.to validate_presence :description }
  it { is_expected.to validate_presence :drm_protected }
end
