require_relative '../../spec_helper'
require 'app/helpers/metadata_helper'

describe EBL::Helpers::MetadataHelper do
  let(:subject) do
    Class.new do
      include EBL::Helpers::MetadataHelper
    end.new
  end

  let(:epub_dbl) { double('epub') }

  before(:each) do
    allow(epub_dbl).to receive(:cover).and_return nil
    allow(EPUBInfo).to receive(:get).and_return epub_dbl

    book = EBL::Models::Book.create(
      title: 'test',
      description: 'test',
      drm_protected: false,
      path: '/path/to/epub'
    )

    book.add_author(
      EBL::Models::Author.new(name: 'author')
    )

    book.add_identifier(
      EBL::Models::Identifier.new(identifier: 'id', scheme: 'scheme')
    )

    book.add_date(
      EBL::Models::Date.new(date: Date.new(2017, 12, 27), event: 'event')
    )

    book.add_subject(EBL::Models::Subject.new(name: 'subject1'))
  end

  describe '#extract_authors_from_epub' do
    context 'when no authors can be found' do
      it 'returns a blank array' do
        allow(epub_dbl).to receive(:creators).and_return []
        expect(subject.extract_authors_from_epub('/epub')).to eq []
      end
    end

    context 'when the ePub contains a list of authors' do
      it 'returns an array of EBL::Models::Author' do
        authors = [
          double('author', name: 'author1'),
          double('author', name: 'author2')
        ]

        allow(epub_dbl).to receive(:creators).and_return authors

        result = subject.extract_authors_from_epub('/epub')
        expect(result.length).to eq 2
        expect(result[0]).to be_a EBL::Models::Author
        expect(result[1]).to be_a EBL::Models::Author
        expect(result[0].name).to eq 'author1'
        expect(result[1].name).to eq 'author2'
      end
    end
  end

  describe '#extract_authors_from_epubinfo' do
    context 'when no authors can be found' do
      it 'returns a blank array' do
        allow(epub_dbl).to receive(:creators).and_return []
        expect(subject.extract_authors_from_epubinfo(epub_dbl)).to eq []
      end
    end

    context 'when the ePub contains a list of authors' do
      it 'returns an array of EBL::Models::Author' do
        authors = [
          double('author', name: 'author1'),
          double('author', name: 'author2')
        ]

        allow(epub_dbl).to receive(:creators).and_return authors

        result = subject.extract_authors_from_epubinfo(epub_dbl)
        expect(result.length).to eq 2
        expect(result[0]).to be_a EBL::Models::Author
        expect(result[1]).to be_a EBL::Models::Author
        expect(result[0].name).to eq 'author1'
        expect(result[1].name).to eq 'author2'
      end

      it 'fetches existing authors, if they already exist' do
        EBL::Models::Author.create(name: 'author2')

        authors = [
          double('author', name: 'author1'),
          double('author', name: 'author2')
        ]

        allow(epub_dbl).to receive(:creators).and_return authors

        result = subject.extract_authors_from_epubinfo(epub_dbl)
        expect(result.length).to eq 2
        expect(result[0]).to be_a EBL::Models::Author
        expect(result[1]).to be_a EBL::Models::Author
        expect(result[0].id).to be_nil
        expect(result[1].id).to_not be_nil
      end

      it 'returns a unique data set' do
        EBL::Models::Author.create(name: 'author2')

        authors = [
          double('author', name: 'author1'),
          double('author', name: 'author2'),
          double('author', name: 'author1'),
          double('author', name: 'author3')
        ]

        allow(epub_dbl).to receive(:creators).and_return authors

        result = subject.extract_authors_from_epubinfo(epub_dbl)
        expect(result.length).to eq 3
        expect(result[0]).to be_a EBL::Models::Author
        expect(result[1]).to be_a EBL::Models::Author
        expect(result[2]).to be_a EBL::Models::Author
        expect(result[0].id).to be_nil
        expect(result[1].id).to_not be_nil
        expect(result[0].name).to eq 'author1'
        expect(result[1].name).to eq 'author2'
        expect(result[2].name).to eq 'author3'
      end
    end
  end

  describe '#extract_dates_from_epubinfo' do
    context 'when no dates can be found' do
      it 'returns a blank array' do
        allow(epub_dbl).to receive(:dates).and_return []
        expect(subject.extract_dates_from_epubinfo(epub_dbl)).to eq []
      end
    end

    context 'when the ePub contains a list of dates' do
      it 'returns an array of EBL::Models::Date' do
        dates = [
          double('date', date: Date.new(2017, 12, 27), event: nil),
          double('date', date: Date.new(2017, 12, 26), event: 'publish')
        ]

        allow(epub_dbl).to receive(:dates).and_return dates

        result = subject.extract_dates_from_epubinfo(epub_dbl)
        expect(result.length).to eq 2
        expect(result[0]).to be_a EBL::Models::Date
        expect(result[1]).to be_a EBL::Models::Date
        expect(result[0].date.to_s).to eq '2017-12-27 00:00:00 +0000'
        expect(result[1].event).to eq 'publish'
      end
    end
  end

  describe '#extract_identifiers_from_epubinfo' do
    context 'when no identifiers can be found' do
      it 'returns a blank array' do
        allow(epub_dbl).to receive(:identifiers).and_return []
        expect(subject.extract_identifiers_from_epubinfo(epub_dbl)).to eq []
      end
    end

    context 'when the ePub contains a list of identifiers' do
      it 'returns an array of EBL::Models::Identifier' do
        identifiers = [
          double('identifier', identifier: '0001', scheme: 'int'),
          double('identifier', identifier: '0001.01', scheme: 'float')
        ]

        allow(epub_dbl).to receive(:identifiers).and_return identifiers

        result = subject.extract_identifiers_from_epubinfo(epub_dbl)
        expect(result.length).to eq 2
        expect(result[0]).to be_a EBL::Models::Identifier
        expect(result[1]).to be_a EBL::Models::Identifier
        expect(result[0].identifier).to eq '0001'
        expect(result[1].scheme).to eq 'float'
      end
    end
  end

  describe '#extract_subjects_from_epubinfo' do
    context 'when no subjects can be found' do
      it 'returns a blank array' do
        allow(epub_dbl).to receive(:subjects).and_return []
        expect(subject.extract_subjects_from_epubinfo(epub_dbl)).to eq []
      end
    end

    context 'when the ePub contains a list of subjects' do
      it 'returns an array of EBL::Models::Subject' do
        subjects = %w[test1 test2]

        allow(epub_dbl).to receive(:subjects).and_return subjects

        result = subject.extract_subjects_from_epubinfo(epub_dbl)
        expect(result.length).to eq 2
        expect(result[0]).to be_a EBL::Models::Subject
        expect(result[1]).to be_a EBL::Models::Subject
        expect(result[0].name).to eq 'test1'
        expect(result[1].name).to eq 'test2'
      end
    end
  end

  describe '#extract_metadata_from_epub' do
    it 'returns a hash containing authors, dates, identifiers and subjects' do
      allow(epub_dbl).to receive(:creators).and_return []
      allow(epub_dbl).to receive(:subjects).and_return []
      allow(epub_dbl).to receive(:identifiers).and_return []
      allow(epub_dbl).to receive(:dates).and_return []

      result = subject.extract_metadata_from_epub('/epub/path')
      expect(result).to have_key :authors
      expect(result).to have_key :dates
      expect(result).to have_key :identifiers
      expect(result).to have_key :subjects
    end
  end

  describe '#update_book_subjects' do
    it 'adds the new subjects to the book' do
      subjects = [
        EBL::Models::Subject.new(name: 'new_subject')
      ]

      book = EBL::Models::Book.first(id: 1)
      expect(book.subjects.first.name).to eq 'subject1'

      subject.update_book_subjects book, subjects
      book = EBL::Models::Book.first(id: 1)

      expect(book.subjects.length).to eq 1
      expect(book.subjects[0].name).to eq 'new_subject'
    end
  end

  describe '#update_book_identifiers' do
    it 'adds the new identifiers to the book' do
      identifiers = [
        EBL::Models::Identifier.new(identifier: 'new_id', scheme: 'scheme')
      ]

      book = EBL::Models::Book.first(id: 1)
      expect(book.identifiers.first.identifier).to eq 'id'

      subject.update_book_identifiers book, identifiers
      book = EBL::Models::Book.first(id: 1)

      expect(book.identifiers.length).to eq 1
      expect(book.identifiers[0].identifier).to eq 'new_id'
    end
  end

  describe '#update_book_authors' do
    it 'adds the new authors to the book' do
      authors = [
        EBL::Models::Author.new(name: 'new_author')
      ]

      book = EBL::Models::Book.first(id: 1)
      expect(book.authors.first.name).to eq 'author'

      subject.update_book_authors book, authors
      book = EBL::Models::Book.first(id: 1)

      expect(book.authors.length).to eq 1
      expect(book.authors[0].name).to eq 'new_author'
    end
  end

  describe '#update_book_dates' do
    it 'adds the new dates to the book' do
      dates = [
        EBL::Models::Date.new(date: Date.new(2018, 1, 4), event: 'new_event')
      ]

      book = EBL::Models::Book.first(id: 1)
      expect(book.dates[0].event).to eq 'event'

      subject.update_book_dates book, dates
      book = EBL::Models::Book.first(id: 1)

      expect(book.dates.length).to eq 1
      expect(book.dates[0].event).to eq 'new_event'
    end
  end
end
