module EBL
  module Helpers
    # A helper module containing methods to serialise objects for
    # consumption by the client application(s).
    module SerialisationHelper
      # Create a hash of the author for consumption by the client application.
      # @param author [EBL::Models::Author] the author to hashify.
      # @return [Hash] a hash of the author data for client consumption.
      def hashify_author(author)
        {
          id:         author.id,
          name:       author.name,
          book_count: author.books.length
        }
      end

      # Create a hash of the book for consumption by the client application.
      # @param book [EBL::Models::Book] the book to hashify.
      # @return [Hash] a hash of the book data for client consumption.
      def hashify_book(book)
        {
          id:            book.id,
          title:         book.title,
          description:   book.description,
          publisher:     book.publisher,
          drm_protected: book.drm_protected,
          epub_version:  book.epub_version,
          rights:        book.rights,
          source:        book.source,
          checksum:      book.checksum,
          subjects:      book.subjects.map { |s| hashify_subject(s) },
          identifiers:   book.identifiers.map { |i| hashify_identifier(i) },
          dates:         book.dates.map { |d| hashify_date(d) }
        }
      end

      # Create a hash of the subject for consumption by the client application.
      # @param subject [EBL::Models::Subject] the subject to hashify.
      # @return [Hash] a hash of the subject data for client consumption.
      def hashify_subject(subject)
        {
          name: subject.name
        }
      end

      # Create a hash of the identifier for consumption by the client application.
      # @param identifier [EBL::Models::Identifier] the identifier to hashify.
      # @return [Hash] a hash of the identifier data for client consumption.
      def hashify_identifier(identifier)
        {
          identifier: identifier.identifier,
          scheme:     identifier.scheme
        }
      end

      # Create a hash of the date for consumption by the client application.
      # @param date [EBL::Models::Date] the date to hashify.
      # @return [Hash] a hash of the date data for client consumption.
      def hashify_date(date)
        {
          date:  date.date.strftime('%Y-%m-%d'),
          event: date.event
        }
      end

      # Create a hash of the user for consumption by the client application.
      # @param user [EBL::Models::User] the user to hashify.
      # @return [Hash] a hash of the user data for client consumption.
      def hashify_user(user)
        {
          id:       user.id,
          username: user.username,
          locked:   user.locked
        }
      end
    end
  end
end
