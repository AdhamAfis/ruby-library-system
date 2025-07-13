require 'sqlite3'
require_relative 'book'

class User
  attr_reader :id, :name

  DB_PATH = 'library.db'

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def self.db
    @db ||= SQLite3::Database.new(DB_PATH)
  end

  def self.create(name, id)
    db.execute("INSERT INTO users (id, name) VALUES (?, ?)", [id, name])
    find_by_id(id)
  end

  def self.find_by_id(id)
    row = db.execute("SELECT id, name FROM users WHERE id = ?", [id]).first
    row ? User.new(id: row[0], name: row[1]) : nil
  end

  def self.all
    db.execute("SELECT id, name FROM users").map { |row| User.new(id: row[0], name: row[1]) }
  end

  def borrow_book(book)
    unless book.available?
      puts "Error: #{book.title} is not available for borrowing"
      return
    end
    if borrowed_books.any? { |b| b.id == book.id }
      puts "Error: #{@name} already borrowed #{book.title}"
      return
    end
    self.class.db.execute("INSERT INTO borrowed_books (user_id, book_id) VALUES (?, ?)", [@id, book.id])
    book.check_out
    puts "#{@name} has borrowed #{book.title}"
  end

  def return_book(book)
    if borrowed_books.any? { |b| b.id == book.id }
      self.class.db.execute("DELETE FROM borrowed_books WHERE user_id = ? AND book_id = ?", [@id, book.id])
      book.return_book
      puts "#{@name} has returned #{book.title}"
    else
      puts "Error: #{@name} does not have #{book.title} borrowed"
    end
  end

  def borrowed_books
    rows = self.class.db.execute("SELECT b.id, b.title, b.author, b.isbn, b.available FROM books b JOIN borrowed_books bb ON b.id = bb.book_id WHERE bb.user_id = ?", [@id])
    rows.map { |row| Book.new(id: row[0], title: row[1], author: row[2], isbn: row[3], available: row[4] == 1) }
  end

  def list_borrowed_books
    books = borrowed_books
    if books.empty?
      puts "#{@name} has no borrowed books"
    else
      puts "#{@name}'s borrowed books:"
      books.each { |book| puts book.title }
    end
  end
end