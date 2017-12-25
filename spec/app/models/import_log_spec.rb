require_relative '../../spec_helper'

describe EBL::Models::ImportLog, type: :model do
  it { is_expected.to have_one_to_one :book }
  it { is_expected.to validate_presence :path }

  describe '.imported?' do
    context 'if a record with a matching path value exists' do
      it 'returns true' do
        described_class.create(path: '/path/to/epub')
        expect(described_class.imported?('/path/to/epub')).to be true
      end
    end

    context 'if a record with a matching path value does not exist' do
      it 'returns false' do
        expect(described_class.imported?('/path/to/epub')).to be false
      end
    end
  end
end
