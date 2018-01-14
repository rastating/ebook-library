require 'app/controllers/base'
require 'app/helpers/serialisation_helper'
require 'app/models/book'

module EBL
  module Controllers
    # Controller for all book related functionality.
    class Books < Base
      include EBL::Helpers::SerialisationHelper
      include EBL::Helpers::CoverHelper

      set :requires_session, true

      # Get all books.
      get '/' do
        json(EBL::Models::Book.all.map { |b| hashify_book(b) })
      end

      # Get a specific book.
      get '/:id' do
        book = EBL::Models::Book.first(id: params['id'])
        halt 404 if book.nil?
        json hashify_book(book)
      end

      # Get the cover of a book
      get '/:id/cover/:filename' do
        book = EBL::Models::Book.first(id: params['id'])
        halt 404 if book.nil?
        send_file(File.join(covers_directory_path, book.cover_path))
      end

      # Get a book's ePub file
      get '/:id/epub/:filename' do
        book = EBL::Models::Book.first(id: params['id'])
        halt 404 if book.nil?
        send_file(book.path)
      end
    end
  end
end
