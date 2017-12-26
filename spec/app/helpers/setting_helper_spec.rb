require_relative '../../spec_helper'
require 'app/helpers/setting_helper'

describe EBL::Helpers::SettingHelper do
  let(:subject) do
    Class.new do
      include EBL::Helpers::SettingHelper
    end.new
  end

  describe '#get_setting_value' do
    context 'when the setting exists' do
      it 'returns the value stored in the database' do
        EBL::Models::Setting.create(key: 'foo', value: 'bar')
        expect(subject.get_setting_value('foo')).to eq 'bar'
      end
    end

    context 'when the setting does not exist' do
      context 'and a default value is not specified' do
        it 'returns nil' do
          expect(subject.get_setting_value('foo')).to be_nil
        end
      end

      context 'and a default value is specified' do
        it 'returns the default value' do
          expect(subject.get_setting_value('foo', 'bar')).to eq 'bar'
        end
      end
    end
  end

  describe '#library_path' do
    it 'gets the value of the library_path setting' do
      EBL::Models::Setting.create(key: 'library_path', value: '/test')
      expect(subject.library_path).to eq '/test'
    end
  end

  describe '#watch_folder_path' do
    it 'gets the value of the watch_folder setting' do
      EBL::Models::Setting.create(key: 'watch_folder', value: '/test')
      expect(subject.watch_folder_path).to eq '/test'
    end
  end
end
