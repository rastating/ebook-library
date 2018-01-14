require 'app/controllers/base'
require 'app/helpers/serialisation_helper'
require 'app/models/author'

module EBL
  module Controllers
    # Controller for all author related functionality.
    class Authors < Base
      include EBL::Helpers::SerialisationHelper

      set :requires_session, true

      # Get all authors.
      get '/' do
        json(EBL::Models::Author.all.map { |a| hashify_author(a) })
      end

      # Get a specific author.
      get '/:id' do
        author = EBL::Models::Author.first(id: params['id'])
        halt 404 if author.nil?
        json hashify_author(author)
      end

      # Get an author's books.
      get '/:id/books' do
        author = EBL::Models::Author.first(id: params['id'])
        halt 404 if author.nil?
        json(author.books.map { |b| hashify_book(b) })
      end
    end
  end
end
