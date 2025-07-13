require 'sqlite3'
require_relative 'book'
require_relative 'user'

class Library
  def add_book(book)
    if Book.find_by_isbn(book.isbn)
      puts "Error: Book with ISBN #{book.isbn} already exists."
    else
      Book.create(book.title, book.author, book.isbn)
      puts "#{book.title} has been added"
    end
  end

  def remove_book(isbn)
    book = Book.find_by_isbn(isbn)
    if book
      unless book.available?
        puts "Error: Cannot remove '#{book.title}' because it is currently checked out."
        return
      end
      Book.db.execute("DELETE FROM books WHERE id = ?", [book.id])
      puts "Book with ISBN #{isbn} has been removed"
    else
      puts "Error: Book with ISBN #{isbn} does not exist."
    end
  end

  def search_books(title, author = nil)
    if title.strip.empty? && (author.nil? || author.strip.empty?)
      puts "Error: Please provide a title or author to search."
      return []
    end
    query = "SELECT id, title, author, isbn, available FROM books WHERE 1=1"
    params = []
    unless title.strip.empty?
      query << " AND LOWER(title) LIKE ?"
      params << "%#{title.downcase}%"
    end
    unless author.nil? || author.strip.empty?
      query << " AND LOWER(author) LIKE ?"
      params << "%#{author.downcase}%"
    end
    rows = Book.db.execute(query, params)
    results = rows.map { |row| Book.new(id: row[0], title: row[1], author: row[2], isbn: row[3], available: row[4] == 1) }
    if results.empty?
      puts "No books found matching your search."
    else
      results.each { |book| puts "#{book.title} by #{book.author}" }
    end
    results
  end

  def register_user(user)
    if User.find_by_id(user.id)
      puts "Error: User ID #{user.id} already exists."
    else
      User.create(user.name, user.id)
      puts "#{user.name} has been registered"
    end
  end

  def lend_book(user_id, isbn)
    user = User.find_by_id(user_id)
    book = Book.find_by_isbn(isbn)
    if !user
      puts "Error: User with ID #{user_id} not found."
    elsif !book
      puts "Error: Book with ISBN #{isbn} not found."
    elsif !book.available?
      puts "Error: '#{book.title}' is not available for lending."
    elsif user.borrowed_books.any? { |b| b.id == book.id }
      puts "Error: User already borrowed '#{book.title}'."
    else
      user.borrow_book(book)
    end
  end

  def receive_book(user_id, isbn)
    user = User.find_by_id(user_id)
    book = Book.find_by_isbn(isbn)
    if !user
      puts "Error: User with ID #{user_id} not found."
    elsif !book
      puts "Error: Book with ISBN #{isbn} not found."
    else
      user.return_book(book)
    end
  end

  def list_all_books
    Book.all.each { |book| puts book.to_s }
  end
end