require_relative '../../spec_helper'
require 'app/helpers/session_helper'

describe EBL::Helpers::SessionHelper do
  let(:subject) do
    Class.new do
      include EBL::Helpers::SessionHelper
    end.new
  end

  let(:session) { { user_id: 1 } }

  before(:each) do
    allow(subject).to receive(:session).and_return session
  end

  describe '#logged_in?' do
    context 'when a user is logged in' do
      it 'returns true' do
        expect(subject.logged_in?).to be true
      end
    end

    context 'when a user is not logged in' do
      let(:session) { {} }
      it 'returns false' do
        expect(subject.logged_in?).to be false
      end
    end
  end
end
