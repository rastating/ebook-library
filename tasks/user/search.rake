namespace :user do
  desc 'Search users by username'
  task :search, [:username] do |_t, args|
    require 'app/models/user'

    User = EBL::Models::User
    users = args[:username].nil? ? User.all : User.where(username: args[:username])

    if users.nil? || users.empty?
      puts 'No users found'
      next
    end

    username_col_width = [users.map { |u| u.username.to_s.length }.max, 8].max
    id_col_width = [users.map { |u| u.id.to_s.length }.max, 2].max

    puts
    print "   ID#{' ' * [id_col_width - 2, 0].max}"
    print "   Username#{' ' * [username_col_width - 8, 0].max}   "
    puts 'Locked'
    puts "   #{'-' * id_col_width}   #{'-' * username_col_width}   ------"
    users.each do |user|
      id_padding = ' ' * [id_col_width - user.id.to_s.length, 0].max
      user_padding = ' ' * [username_col_width - user.username.to_s.length, 0].max
      locked = user.locked ? 'Yes' : 'No'
      puts "   #{user.id}#{id_padding}   #{user.username}#{user_padding}   #{locked}"
    end
    puts
  end
end
