require 'app/controllers/base'
require 'app/helpers/serialisation_helper'
require 'app/models/author'

module EBL
  module Controllers
    # Controller for all author related functionality.
    class Authors < Base
      include EBL::Helpers::SerialisationHelper
      include EBL::Helpers::CoverHelper

      set :requires_session, true

      # Get all authors.
      get '/' do
        json(EBL::Models::Author.order(:name).all.map { |a| hashify_author(a) })
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
        json(author.books_dataset.order(:title).map { |b| hashify_book(b) })
      end

      # Get an array of cover URLs for books by the specified author.
      get '/:id/books/covers' do
        author = EBL::Models::Author.first(id: params['id'])
        halt 404 if author.nil?

        covers = []
        author.books.each do |book|
          unless book.cover_path.to_s.empty?
            covers.push "/api/books/#{book.id}/cover/#{book.cover_path}"
          end
        end

        json covers
      end
    end
  end
end
