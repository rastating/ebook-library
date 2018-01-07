require_relative '../../spec_helper'
require 'app/models/setting'

describe EBL::Models::Setting, type: :model do
  it { is_expected.to validate_max_length 50, :key }
  it { is_expected.to validate_presence :key }
  it { is_expected.to validate_unique :key }
  it { is_expected.to validate_presence :value }

  describe '.create_or_update' do
    context 'when the setting does not exist' do
      it 'creates the setting' do
        setting = described_class.first(key: 'test')
        expect(setting).to be_nil

        described_class.create_or_update('test', 'value')
        setting = described_class.first(key: 'test')
        expect(setting.value).to eq 'value'
      end
    end

    context 'when the setting exists' do
      it 'updates the setting' do
        described_class.create(key: 'test', value: 'value')
        setting = described_class.first(key: 'test')
        expect(setting.value).to eq 'value'

        described_class.create_or_update('test', 'new_value')
        setting = described_class.first(key: 'test')
        expect(setting.value).to eq 'new_value'
      end
    end
  end
end
