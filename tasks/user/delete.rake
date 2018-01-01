namespace :user do
  desc 'Delete a user by their ID number'
  task :delete, [:id] do |_t, args|
    require 'app/models/user'

    logger = EBL::Logger.new('user:delete')
    user = EBL::Models::User.first(id: args[:id])

    if user.nil?
      logger.log "User #{args[:id]} does not exist", :red
      next
    end

    user.destroy
    logger.log "Deleted user #{args[:id]}", :green
  end
end
