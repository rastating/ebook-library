require_relative '../spec_helper'
require 'app/controllers/base'

describe EBL::Controllers::Base do
  let(:app) { described_class }

  it_behaves_like 'a route controller'
end
