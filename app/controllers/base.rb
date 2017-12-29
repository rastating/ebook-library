module EBL
  module Controllers
    # Base controller for all routes.
    class Base < Sinatra::Base
      enable :sessions

      use Rack::CommonLogger, EBL::Logger.new('rack:api')

      set :requires_session, false

      configure :production, :test do
        error do
          json error: true
        end
      end

      not_found do
        json error: true, not_found: true
      end

      before do
        pass unless settings.requires_session
        halt 401 unless logged_in?
      end

      def logged_in?
        !session[:username].nil?
      end
    end
  end
end
