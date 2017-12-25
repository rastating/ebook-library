require_relative '../../spec_helper'

describe EBL::Models::ImportLog, type: :model do
  it { is_expected.to have_one_to_one :book }
  it { is_expected.to validate_presence :path }
end
