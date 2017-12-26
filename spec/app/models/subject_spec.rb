require_relative '../../spec_helper'
require 'app/models/subject'

describe EBL::Models::Subject, type: :model do
  it { is_expected.to have_many_to_one :book }
  it { is_expected.to validate_max_length 100, :name }
end
