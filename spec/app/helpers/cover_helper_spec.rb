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

  describe '#save_cover_to_disk' do
    it 'saves the cover and returns the assigned file name' do
      cover = double('EPubInfo::Models::Cover')
      allow(cover).to receive(:tempfile).and_return('/tmp/test')
      allow(cover).to receive(:original_file_name).and_return('cover.jpg')

      book = double('EPubInfo::Models::Book')
      allow(book).to receive(:id).and_return(7)

      expect(subject.save_cover_to_disk(book, cover)).to eq '7_cover.jpg'
    end
  end
end
