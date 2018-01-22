namespace :author do
  desc 'Search authors by name'
  task :search, [:name] do |_t, args|
    require 'app/models/author'

    Author = EBL::Models::Author
    authors = args[:name].nil? ? Author.all : Author.where(Sequel.like(:name, "%#{args[:name]}%"))

    if authors.nil? || authors.empty?
      puts 'No authors found'
      next
    end

    name_col_width = [authors.map { |a| a.name.to_s.length }.max, 4].max
    id_col_width = [authors.map { |a| a.id.to_s.length }.max, 2].max

    puts
    print "   ID#{' ' * [id_col_width - 2, 0].max}"
    print "   Name#{' ' * [name_col_width - 4, 0].max}   "
    puts 'Books'
    puts "   #{'-' * id_col_width}   #{'-' * name_col_width}   -----"
    authors.each do |author|
      id_padding = ' ' * [id_col_width - author.id.to_s.length, 0].max
      name_padding = ' ' * [name_col_width - author.name.to_s.length, 0].max
      books = author.books.length
      puts "   #{author.id}#{id_padding}   #{author.name}#{name_padding}   #{books}"
    end
    puts
  end
end
