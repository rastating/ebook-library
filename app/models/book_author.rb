module EBL
  module Models
    # An association object connecting books and authors.
    class BookAuthor < Sequel::Model
      many_to_many :authors
      many_to_many :books
    end
  end
end
