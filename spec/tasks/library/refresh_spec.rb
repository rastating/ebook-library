require_relative '../../spec_helper'
load 'tasks/library/refresh.rake'

describe 'rake library:refresh', type: :task do
  let(:subject) { Rake::Task['library:refresh'] }

  before(:each) do
    subject.reenable
    allow_any_instance_of(EBL::Logger).to receive(:log)
  end

  it 'runs the refresh metadata job' do
    executed_job = false
    Job = EBL::Jobs::RefreshMetadataJob
    allow_any_instance_of(Job).to receive(:perform) { executed_job = true }
    subject.invoke
    expect(executed_job).to be true
  end
end
