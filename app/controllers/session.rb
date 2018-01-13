require 'app/controllers/base'
require 'app/helpers/serialisation_helper'
require 'app/models/user'

module EBL
  module Controllers
    # Controller for session management operations.
    class Session < Base
      include EBL::Helpers::SerialisationHelper

      # Get session state
      get '/' do
        halt 404 unless logged_in?
        json hashify_user(logged_in_user)
      end

      post '/' do
        data = {}

        begin
          data = JSON.parse(request.body.read)
        rescue JSON::ParserError
          halt 500, json(error: true, message: 'Malformed body')
        end

        user = EBL::Models::User.find_and_verify(
          data['username'],
          data['password']
        )

        halt 404 if user.nil?

        session[:user_id] = user.id
        json hashify_user(user)
      end

      delete '/' do
        session[:user_id] = nil
        json success: true
      end
    end
  end
end
