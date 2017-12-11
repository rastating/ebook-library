require_relative '../../spec_helper'

describe EBL::Models::Identifier, type: :model do
  it { is_expected.to have_many_to_one :book }
  it { is_expected.to validate_max_length 100, :identifier }
  it { is_expected.to validate_max_length 50, :scheme, allow_nil: true }
end
