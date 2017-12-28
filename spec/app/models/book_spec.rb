require_relative '../../spec_helper'
require 'app/models/book'

describe EBL::Models::Book, type: :model do
  let(:subject) { described_class.new }
  let(:epub_dbl) do
    double(
      'epub',
      titles: %w[title],
      description: 'desc',
      drm_protected: false
    )
  end

  before(:each) do
    EBL::Models::Book.create(
      title: 'test',
      description: 'test',
      drm_protected: false,
      path: '/test',
      checksum: 'test'
    )
  end

  it { is_expected.to have_many_to_many :authors }
  it { is_expected.to have_one_to_many :subjects }
  it { is_expected.to have_one_to_many :identifiers }
  it { is_expected.to have_one_to_many :dates }

  it { is_expected.to validate_max_length 200, :title }
  it { is_expected.to validate_max_length 500, :publisher, allow_nil: true }
  it { is_expected.to validate_max_length 500, :rights, allow_nil: true }
  it { is_expected.to validate_max_length 200, :source, allow_nil: true }
  it { is_expected.to validate_max_length 100, :checksum, allow_nil: true }

  it { is_expected.to validate_max_length 10, :epub_version, allow_nil: true }

  it { is_expected.to validate_presence :description }
  it { is_expected.to validate_presence :drm_protected }
  it { is_expected.to validate_presence :path }

  describe '#refresh_checksum' do
    context 'when #path is empty' do
      it 'sets #checksum to a blank string' do
        expect(subject.checksum).to be_nil
        subject.path = ''
        subject.refresh_checksum
        expect(subject.checksum).to eq ''
      end
    end

    context 'when #path is nil' do
      it 'sets #checksum to a blank string' do
        expect(subject.checksum).to be_nil
        subject.path = nil
        subject.refresh_checksum
        expect(subject.checksum).to eq ''
      end
    end

    context 'when the file in #path does not exist' do
      it 'sets #checksum to a blank string' do
        expect(subject.checksum).to be_nil
        subject.path = '/this/file/could/not/possibly/exist.test'
        subject.refresh_checksum
        expect(subject.checksum).to eq ''
      end
    end

    context 'when the file in #path exists' do
      it 'sets #checksum to the MD5 hash of the file in #path' do
        allow(File).to receive(:read).and_return('test')
        allow(File).to receive(:exist?).and_return(true)

        subject.path = '/test'
        expect(subject.checksum).to be_nil

        subject.refresh_checksum
        expect(subject.checksum).to eq '098f6bcd4621d373cade4e832627b4f6'
      end
    end
  end

  describe '#update_path_and_refresh_checksum' do
    context 'when path is empty' do
      it 'sets #checksum to a blank string' do
        expect(subject.checksum).to be_nil
        subject.update_path_and_refresh_checksum ''
        expect(subject.checksum).to eq ''
      end
    end

    context 'when path is nil' do
      it 'sets #checksum to a blank string' do
        expect(subject.checksum).to be_nil
        subject.update_path_and_refresh_checksum nil
        expect(subject.checksum).to eq ''
      end
    end

    context 'when the file in path does not exist' do
      it 'sets #checksum to a blank string' do
        expect(subject.checksum).to be_nil
        subject.update_path_and_refresh_checksum '/this/will/not/exist.test'
        expect(subject.checksum).to eq ''
      end
    end

    context 'when the file in path exists' do
      it 'sets #checksum to the MD5 hash of the file in path' do
        allow(File).to receive(:read).and_return('test')
        allow(File).to receive(:exist?).and_return(true)

        expect(subject.checksum).to be_nil

        subject.update_path_and_refresh_checksum '/test'
        expect(subject.checksum).to eq '098f6bcd4621d373cade4e832627b4f6'
      end
    end

    context 'when should_save is set to true' do
      it 'will call #save at the end of the process' do
        allow(File).to receive(:read).and_return('test')
        allow(File).to receive(:exist?).and_return(true)

        invoked_save = false
        allow(subject).to receive(:save) do
          invoked_save = true
        end

        subject.update_path_and_refresh_checksum '/test', true
        expect(invoked_save).to be true
      end
    end
  end

  describe '#primary_author' do
    context 'when no authors are associated with the book' do
      it 'returns "Unknown"' do
        expect(subject.authors.count).to eq 0
        expect(subject.primary_author).to eq 'Unknown'
      end
    end

    context 'when the author name is blank' do
      it 'returns "Unknown"' do
        subject = EBL::Models::Book.first
        subject.add_author(name: '')
        expect(subject.authors.count).to eq 1
        expect(subject.primary_author).to eq 'Unknown'
      end
    end

    context 'when one or more valid authors exist' do
      it 'returns the name of the first author' do
        subject = EBL::Models::Book.first
        subject.add_author(name: 'Emmanuel Goldstein')
        subject.add_author(name: 'George Orwell')
        expect(subject.primary_author).to eq 'Emmanuel Goldstein'
      end
    end
  end

  describe '.from_epub' do
    it 'creates an unsaved Book from the metadata of the file at path' do
      allow(File).to receive(:read).and_return('test')
      allow(File).to receive(:exist?).and_return(true)
      allow(EPUBInfo).to receive(:get).and_return epub_dbl

      subject = EBL::Models::Book.from_epub('/test')

      expect(subject.title).to eq 'title'
      expect(subject.description).to eq 'desc'
      expect(subject.drm_protected).to be false
      expect(subject.checksum).to eq '098f6bcd4621d373cade4e832627b4f6'
    end

    it 'sets a default #description if it is blank or nil' do
      allow(File).to receive(:read).and_return('test')
      allow(File).to receive(:exist?).and_return(true)
      allow(EPUBInfo).to receive(:get).and_return epub_dbl
      allow(epub_dbl).to receive(:description).and_return ''

      subject = EBL::Models::Book.from_epub('/test')
      expect(subject.description).to eq 'This book has no description'
    end
  end
end
