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
end
