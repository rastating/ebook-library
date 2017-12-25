require_relative '../../spec_helper'

describe EBL::Helpers::LibraryFileSystemHelper do
  let(:subject) do
    Class.new do
      include EBL::Helpers::LibraryFileSystemHelper
    end.new
  end

  let(:book_dbl) do
    double(
      'book',
      id: 99,
      title: 'title',
      primary_author: 'author!',
      path: '/original/path'
    )
  end

  describe '#dot_file?' do
    it 'returns true if filename is . or ..' do
      expect(subject.dot_file?('.')).to be true
      expect(subject.dot_file?('..')).to be true
      expect(subject.dot_file?('test')).to be false
    end
  end

  describe '#epub?' do
    it 'returns true if the extension of filename is .epub' do
      expect(subject.epub?('test.epub')).to be true
      expect(subject.epub?('test..doc..epub')).to be true
      expect(subject.epub?('test.doc')).to be false
    end
  end

  describe '#safe_name' do
    it 'replaces unsafe characters with an underscore' do
      expect(subject.safe_name('test')).to eq 'test'
      expect(subject.safe_name('te!st')).to eq 'te_st'
      expect(subject.safe_name('!@#$%^&*()=<>?.\'"|')).to(
        eq '__________________'
      )
    end
  end

  describe '#copy_book_to_library' do
    it 'attempts to create the author folder, if it does not exist' do
      created_author_folder = false
      author_path = '/library/path/author_'

      allow(subject).to receive(:library_path).and_return('/library/path')

      allow(FileUtils).to receive(:cp).and_return true
      allow(FileUtils).to receive(:mkdir_p) do |p1|
        created_author_folder = (p1 == author_path)
      end

      subject.copy_book_to_library(book_dbl)
      expect(created_author_folder).to be true
    end

    it 'copies the file in book#path to the library' do
      copied_to_dest = false
      dest_path = '/library/path/author_/99_title.epub'

      allow(subject).to receive(:library_path).and_return('/library/path')

      allow(FileUtils).to receive(:mkdir_p).and_return true
      allow(FileUtils).to receive(:cp) do |p1, p2|
        copied_to_dest = p1 == book_dbl.path && p2 == dest_path
      end

      subject.copy_book_to_library(book_dbl)
      expect(copied_to_dest).to be true
    end

    context 'when the file fails to copy to the library' do
      it 'returns false' do
        allow(subject).to receive(:library_path).and_return('/library/path')

        allow(FileUtils).to receive(:mkdir_p).and_return true
        allow(FileUtils).to receive(:cp).and_return true
        allow(FileUtils).to receive(:exist?).and_return false

        expect(subject.copy_book_to_library(book_dbl)).to be false
      end
    end

    context 'when the file is copied to the library' do
      it 'returns true' do
        allow(subject).to receive(:library_path).and_return('/library/path')
        allow(book_dbl).to(
          receive(:update_path_and_refresh_checksum)
            .and_return(true)
        )

        allow(FileUtils).to receive(:mkdir_p).and_return true
        allow(FileUtils).to receive(:cp).and_return true
        allow(File).to receive(:exist?).and_return true

        expect(subject.copy_book_to_library(book_dbl)).to be true
      end

      it 'refreshes the path and checksum, and saves the book' do
        set_path = false
        saved = false

        allow(subject).to receive(:library_path).and_return('/library/path')
        allow(book_dbl).to(
          receive(:update_path_and_refresh_checksum) do |p1, p2|
            set_path = (p1 == '/library/path/author_/99_title.epub')
            saved = p2
          end
        )

        allow(FileUtils).to receive(:mkdir_p).and_return true
        allow(FileUtils).to receive(:cp).and_return true
        allow(File).to receive(:exist?).and_return true

        expect(subject.copy_book_to_library(book_dbl)).to be true
        expect(set_path).to be true
        expect(saved).to be true
      end
    end
  end
end
