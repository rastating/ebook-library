require_relative '../../spec_helper'
require 'app/helpers/serialisation_helper'

describe EBL::Helpers::SerialisationHelper do
  let(:subject) do
    Class.new do
      include EBL::Helpers::SerialisationHelper
    end.new
  end

  describe '#hashify_author' do
    it 'contains the id, name and book count of the author' do
      book = EBL::Models::Book.create(
        title: 'test',
        description: 'test',
        drm_protected: false,
        path: '/path/to/epub'
      )

      book.add_author(EBL::Models::Author.create(name: 'test'))

      author = EBL::Models::Author.first(id: 1)
      hashified_author = { id: 1, name: 'test', book_count: 1 }
      expect(subject.hashify_author(author)).to eq hashified_author
    end
  end

  describe '#hashify_user' do
    it 'contains the id and username the user' do
      EBL::Models::User.create(
        username: 'test',
        password: 'test',
        locked: true
      )

      user = EBL::Models::User.first(id: 1)
      hashified_user = { id: 1, username: 'test', locked: true }
      expect(subject.hashify_user(user)).to eq hashified_user
    end
  end

  describe '#hashify_date' do
    it 'returns a hash of the object' do
      date = EBL::Models::Date.new(
        date:  '2018-01-13',
        event: 'test'
      )

      hashified_date = { date: '2018-01-13', event: 'test' }
      expect(subject.hashify_date(date)).to eq hashified_date
    end
  end

  describe '#hashify_identifier' do
    it 'returns a hash of the identifier' do
      identifier = EBL::Models::Identifier.new(
        identifier: 'test',
        scheme:     'test'
      )

      hash = { identifier: 'test', scheme: 'test' }
      expect(subject.hashify_identifier(identifier)).to eq hash
    end
  end

  describe '#hashify_subject' do
    it 'returns a hash of the subject' do
      s = EBL::Models::Subject.new(
        name: 'test'
      )

      hash = { name: 'test' }
      expect(subject.hashify_subject(s)).to eq hash
    end
  end

  describe '#hashify_book' do
    it 'returns a hash of the book' do
      book = EBL::Models::Book.create(
        title:         'title',
        description:   'description',
        publisher:     'publisher',
        drm_protected: true,
        epub_version:  1,
        rights:        'rights',
        source:        'source',
        checksum:      'checksum',
        path:          '/path/to/epub.epub',
        cover_path:    'book.jpg'
      )

      book.add_subject(EBL::Models::Subject.new(name: 'subject1'))
      book.add_subject(EBL::Models::Subject.new(name: 'subject2'))

      book.add_identifier(
        EBL::Models::Identifier.new(identifier: 'test', scheme: 'test')
      )

      book.add_date(EBL::Models::Date.new(date: '2018-01-13', event: 'test'))
      book.add_date(EBL::Models::Date.new(date: '2018-01-14', event: 'test'))

      hash = {
        id:            1,
        title:         'title',
        description:   'description',
        publisher:     'publisher',
        drm_protected: true,
        epub_version:  1,
        rights:        'rights',
        source:        'source',
        checksum:      'checksum',
        cover:         'book.jpg',
        epub_name:     'epub.epub',
        subjects:      [
          { name: 'subject1' },
          { name: 'subject2' }
        ],
        identifiers:   [
          { identifier: 'test', scheme: 'test' }
        ],
        dates:         [
          { date: '2018-01-13', event: 'test' },
          { date: '2018-01-14', event: 'test' }
        ]
      }

      expect(subject.hashify_book(book)).to eq hash
    end
  end
end
