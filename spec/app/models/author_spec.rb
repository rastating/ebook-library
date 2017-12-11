require_relative '../../spec_helper'

describe EBL::Models::Author, type: :model do
  it { is_expected.to have_many_to_one :book }
  it { is_expected.to validate_max_length 500, :name }
end
