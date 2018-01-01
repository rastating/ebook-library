module EBL
  module Helpers
    # A helper module containing methods to access and manipulate
    # user sessions.
    module SessionHelper
      # @return [Boolean] true if the user is logged in.
      def logged_in?
        !session[:user_id].nil?
      end

      # @return [EBL::Models::User, nil] the logged in user or nil.
      def logged_in_user
        EBL::Models::User.first(id: session[:user_id])
      end
    end
  end
end
