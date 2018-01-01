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
          id: author.id,
          name: author.name,
          book_count: author.books.length
        }
      end

      # Create a hash of the user for consumption by the client application.
      # @param user [EBL::Models::User] the user to hashify.
      # @return [Hash] a hash of the user data for client consumption.
      def hashify_user(user)
        {
          id: user.id,
          username: user.username,
          locked: user.locked
        }
      end
    end
  end
end
