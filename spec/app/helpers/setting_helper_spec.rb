require_relative '../../spec_helper'

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
end
