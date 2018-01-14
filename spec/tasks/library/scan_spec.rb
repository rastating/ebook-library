require_relative '../../spec_helper'
require 'app/models/setting'
load 'tasks/library/scan.rake'

describe 'rake library:scan', type: :task do
  let(:subject) { Rake::Task['library:scan'] }

  before(:each) do
    subject.reenable
    allow_any_instance_of(EBL::Logger).to receive(:log)
  end

  it 'runs the epub scan job against the watch folder' do
    EBL::Models::Setting.create_or_update('watch_folder', '/path/to/watch')
    executed_job = false
    Job = EBL::Jobs::EpubScanJob

    allow_any_instance_of(Job).to receive(:perform) do |_t, p1|
      executed_job = p1 == '/path/to/watch'
    end

    subject.invoke
    expect(executed_job).to be true
  end
end
