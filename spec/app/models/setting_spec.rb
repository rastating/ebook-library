require_relative '../../spec_helper'

describe EBL::Models::Setting, type: :model do
  it { is_expected.to validate_max_length 50, :key }
  it { is_expected.to validate_presence :key }
  it { is_expected.to validate_unique :key }
  it { is_expected.to validate_presence :value }
end
