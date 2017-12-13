require_relative '../../spec_helper'

describe EBL::Helpers::CoverHelper do
  let(:subject) do
    Class.new do
      include EBL::Helpers::CoverHelper
    end.new
  end

  describe '#covers_directory_path' do
    context 'when the covers_path setting exists' do
      it 'returns the value stored in the database' do
        EBL::Models::Setting.create(key: 'covers_path', value: '/covers/path')
        expect(subject.covers_directory_path).to eq '/covers/path'
      end
    end

    context 'when the covers_path setting does not exist' do
      it 'returns the default path' do
        base = File.expand_path('../../../', __dir__)
        path = File.join(base, 'public', 'assets', 'images', 'covers')
        expect(subject.covers_directory_path).to eq path
      end
    end
  end
end
