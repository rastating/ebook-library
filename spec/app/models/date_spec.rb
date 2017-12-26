require_relative '../../spec_helper'
require 'app/models/date'

describe EBL::Models::Date, type: :model do
  it { is_expected.to have_many_to_one :book }
  it { is_expected.to validate_presence :date }
  it { is_expected.to validate_max_length 50, :event, allow_nil: true }
end
