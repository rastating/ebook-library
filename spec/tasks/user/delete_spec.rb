require_relative '../../spec_helper'
load 'tasks/user/delete.rake'

describe 'rake user:delete', type: :task do
  let(:subject) { Rake::Task['user:delete'] }

  before(:each) do
    subject.reenable
    allow_any_instance_of(EBL::Logger).to receive(:log)
  end

  context 'when the user does not exist' do
    it 'logs an error' do
      logged = false
      allow_any_instance_of(EBL::Logger).to receive(:log) do |_t, p1, p2|
        logged = (p1 == 'User 1 does not exist') && (p2 == :red)
      end

      subject.invoke 1
      expect(logged).to be true
    end
  end

  context 'when the user exists' do
    it 'deletes the specified user' do
      EBL::Models::User.create(username: 'test', password: 'test')
      user = EBL::Models::User.find(id: 1)
      expect(user).to_not be_nil

      subject.invoke 1

      user = EBL::Models::User.find(id: 1)
      expect(user).to be_nil
    end
  end
end
