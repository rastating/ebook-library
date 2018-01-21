require 'bcrypt'

module EBL
  module Models
    # A user of the system.
    class User < Sequel::Model
      plugin :validation_helpers

      def validate
        super

        validates_max_length 50, :username
        validates_max_length 100, :password

        validates_format(/^[a-zA-Z0-9]+$/, :username)
      end

      # Create a new password hash and assign it to #password.
      # @param plain_text [String] the plain text password.
      # @return [String] the hashed password.
      def create_password_hash(plain_text)
        hash = BCrypt::Password.create(plain_text)
        self.password = hash.to_s
        hash.to_s
      end

      # Find a user with the matching username and password.
      # @param username [String] the user's username.
      # @param password [String] the user's plain text password.
      # @return [EBL::Models::User] the user model, if it exists and
      #   the password specified is correct. Otherwise, returns nil.
      def self.find_and_verify(username, password)
        user = User.first(username: username.downcase)
        return nil if user.nil?

        hash = BCrypt::Password.new(user.password)
        return user if hash == password

        nil
      end
    end
  end
end
