require_relative '../../spec_helper'
load 'tasks/library/setup.rake'

describe 'rake library:setup', type: :task do
  let(:subject)     { Rake::Task['library:setup'] }
  let(:first_path)  { '/first/path' }
  let(:second_path) { '/second/path' }

  before(:each) do
    subject.reenable
    allow_any_instance_of(EBL::Logger).to receive(:log)
    allow_any_instance_of(EBL::InputHandler).to(
      receive(:get_path).and_return(first_path, second_path)
    )
  end

  it 'sets the value of the library_path setting' do
    setting = EBL::Models::Setting.find(key: 'library_path')
    expect(setting).to be_nil

    subject.invoke
    setting = EBL::Models::Setting.find(key: 'library_path')
    expect(setting.value).to eq '/first/path'
  end

  it 'sets the value of the watch_folder setting' do
    setting = EBL::Models::Setting.find(key: 'watch_folder')
    expect(setting).to be_nil

    subject.invoke
    setting = EBL::Models::Setting.find(key: 'watch_folder')
    expect(setting.value).to eq '/second/path'
  end
end
