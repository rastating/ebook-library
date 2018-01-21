namespace :user do
  desc 'Run the new user wizard'
  task :create do
    require 'app/models/user'
    require 'lib/ebl/input_handler'

    logger = EBL::Logger.new
    logger.context = 'user:create'
    input = EBL::InputHandler.new(logger)

    username = input.get_alphanumeric_value('username', 3, 50)
    next if username.nil?

    unless EBL::Models::User.find(username: username.downcase).nil?
      logger.log "#{username} already exists", :red
      next
    end

    password = input.get_password(4)
    next if password.nil?

    user = EBL::Models::User.new
    user.username = username.downcase
    user.create_password_hash password
    user.save

    logger.log "Created user: #{username}", :green
  end
end
