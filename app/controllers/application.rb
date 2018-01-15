require 'app/controllers/base'

module EBL
  module Controllers
    # Controller for setting up the public folder and handling
    # miscellaneous requests for application specific resources.
    class Application < Base
      set :public_folder, 'public/build'

      # Catch all requests that do not match a static resource.
      get '/*' do
        send_file 'public/build/index.html'
      end
    end
  end
end
