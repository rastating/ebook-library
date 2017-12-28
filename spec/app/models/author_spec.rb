require_relative '../../spec_helper'
require 'app/models/author'

describe EBL::Models::Author, type: :model do
  it { is_expected.to have_many_to_many :books }
  it { is_expected.to validate_max_length 500, :name }
  it { is_expected.to validate_unique :name }
end
