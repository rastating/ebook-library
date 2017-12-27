require_relative '../../spec_helper'
require 'app/jobs/refresh_metadata_job'

describe EBL::Jobs::RefreshMetadataJob do
  let(:subject) { described_class.new }
  let(:epub_dbl) { double('epub') }

  let(:metadata_dbl) do
    double(
      'metadata',
      authors: [],
      dates: [],
      identifiers: [],
      subjects: []
    )
  end

  let(:book_dbl) do
    double(
      'book',
      path: '/path/to/epub',
      remove_all_authors: true,
      remove_all_dates: true,
      remove_all_identifiers: true,
      remove_all_subjects: true
    )
  end

  before(:each) do
    allow(EPUBInfo).to receive(:get).and_return epub_dbl
    allow(subject).to receive(:extract_metadata_from_epub).and_return metadata_dbl

    EBL::Models::Book.create(
      title: 'test',
      description: 'test',
      drm_protected: false,
      path: '/path/to/epub'
    )
  end

  describe '#perform' do
    it 'logs an error if the book cannot be found' do
      logged_error = false

      allow(subject).to receive(:log_error) do |p1|
        logged_error = (p1 == 'Could not find book -99')
      end

      subject.perform(-99)
      expect(logged_error).to be true
    end

    context 'when ignore_checksum is false' do
      context 'and the checksum of the file has changed' do
        it 'calls #update_metadata' do
          update_metadata_called = false

          allow(subject).to receive(:checksum_changed?).and_return true
          allow(subject).to receive(:update_metadata) do
            update_metadata_called = true
          end

          subject.perform(1)
          expect(update_metadata_called).to be true
        end
      end

      context 'and the checksum of the file has not changed' do
        it 'returns and does not update the metadata' do
          update_metadata_called = false

          allow(subject).to receive(:checksum_changed?).and_return false
          allow(subject).to receive(:update_metadata) do
            update_metadata_called = true
          end

          subject.perform(1)
          expect(update_metadata_called).to be false
        end
      end
    end

    context 'when ignore_checksum is true' do
      context 'and the checksum has not changed' do
        it 'updates the metadata' do
          update_metadata_called = false

          allow(subject).to receive(:checksum_changed?).and_return false
          allow(subject).to receive(:update_metadata) do
            update_metadata_called = true
          end

          subject.perform(1, true)
          expect(update_metadata_called).to be true
        end
      end

      context 'and the checksum has changed' do
        it 'updates the metadata' do
          update_metadata_called = false

          allow(subject).to receive(:checksum_changed?).and_return true
          allow(subject).to receive(:update_metadata) do
            update_metadata_called = true
          end

          subject.perform(1, true)
          expect(update_metadata_called).to be true
        end
      end
    end
  end

  describe '#update_metadata' do
    it 'removes all existing authors' do
      removed = false

      allow(book_dbl).to receive(:remove_all_authors) do
        removed = true
      end

      subject.book = book_dbl
      subject.update_metadata
      expect(removed).to be true
    end

    it 'removes all existing dates' do
      removed = false

      allow(book_dbl).to receive(:remove_all_dates) do
        removed = true
      end

      subject.book = book_dbl
      subject.update_metadata
      expect(removed).to be true
    end

    it 'removes all existing identifiers' do
      removed = false

      allow(book_dbl).to receive(:remove_all_identifiers) do
        removed = true
      end

      subject.book = book_dbl
      subject.update_metadata
      expect(removed).to be true
    end

    it 'removes all existing subjects' do
      removed = false

      allow(book_dbl).to receive(:remove_all_subjects) do
        removed = true
      end

      subject.book = book_dbl
      subject.update_metadata
      expect(removed).to be true
    end

    it 'adds the new metadata to the book' do
      authors = [
        EBL::Models::Author.new(name: 'author')
      ]

      subjects = [
        EBL::Models::Subject.new(name: 'subject')
      ]

      identifiers = [
        EBL::Models::Identifier.new(identifier: 'id', scheme: 'scheme')
      ]

      dates = [
        EBL::Models::Date.new(date: Date.new(2017, 12, 27), event: 'event')
      ]

      allow(metadata_dbl).to receive(:authors).and_return authors
      allow(metadata_dbl).to receive(:subjects).and_return subjects
      allow(metadata_dbl).to receive(:identifiers).and_return identifiers
      allow(metadata_dbl).to receive(:dates).and_return dates

      subject.book = EBL::Models::Book.first(id: 1)
      subject.update_metadata

      book = EBL::Models::Book.first(id: 1)

      expect(book.authors.length).to eq 1
      expect(book.subjects.length).to eq 1
      expect(book.identifiers.length).to eq 1
      expect(book.dates.length).to eq 1

      expect(book.authors[0].name).to eq 'author'
      expect(book.subjects[0].name).to eq 'subject'
      expect(book.identifiers[0].identifier).to eq 'id'
      expect(book.dates[0].event).to eq 'event'
    end
  end
end
