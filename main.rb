require_relative 'book'
require_relative 'user'
require_relative 'library'
require 'sqlite3'

# Ensure DB and tables exist
require_relative 'db_setup'

# Seed initial data if not present
if Book.find_by_isbn("978-1338878950").nil?
  Book.create("Harry Potter and the Goblet of fire", "J.K Rowling", "978-1338878950")
end
if Book.find_by_isbn("978-1338878936").nil?
  Book.create("Harry Potter and the Chamber of Secrets", "J.K Rowling", "978-1338878936")
end
if User.find_by_id(1).nil?
  User.create("Adham", 1)
end

library = Library.new

puts "Welcome to the Library Management System"

def prompt(msg)
  print msg
  gets.chomp
end

loop do
  puts "\nChoose an action:"
  puts "1. Add a new book"
  puts "2. Register a new user"
  puts "3. Search for books"
  puts "4. Lend a book"
  puts "5. Return a book"
  puts "6. List borrowed books for a user"
  puts "7. Remove a book"
  puts "8. List all books"
  puts "9. Exit"
  choice = prompt("Enter your choice (1-9): ")

  case choice
  when "1"
    title = prompt("Book title: ")
    author = prompt("Author: ")
    isbn = prompt("ISBN: ")
    library.add_book(Book.new(id: nil, title: title, author: author, isbn: isbn))
  when "2"
    name = prompt("User name: ")
    id = prompt("User ID (number): ").to_i
    if User.find_by_id(id)
      puts "User ID already exists."
    else
      user = User.new(id: id, name: name)
      library.register_user(user)
    end
  when "3"
    title = prompt("Search title (leave blank for any): ")
    author = prompt("Search author (leave blank for any): ")
    library.search_books(title, author.empty? ? nil : author)
  when "4"
    user_id = prompt("User ID: ").to_i
    isbn = prompt("Book ISBN: ")
    library.lend_book(user_id, isbn)
  when "5"
    user_id = prompt("User ID: ").to_i
    isbn = prompt("Book ISBN: ")
    library.receive_book(user_id, isbn)
  when "6"
    user_id = prompt("User ID: ").to_i
    user = User.find_by_id(user_id)
    if user
      user.list_borrowed_books
    else
      puts "User not found."
    end
  when "7"
    isbn = prompt("Book ISBN to remove: ")
    library.remove_book(isbn)
  when "8"
    puts "All books in the library:"
    library.list_all_books
  when "9"
    break
  else
    puts "Invalid choice. Try again"
  end
end