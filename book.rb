require 'sqlite3'

class Book
  attr_reader :id, :title, :author, :isbn

  DB_PATH = 'library.db'

  def initialize(id:, title:, author:, isbn:, available: true)
    @id = id
    @title = title
    @author = author
    @isbn = isbn
    @available = available
  end

  def self.db
    @db ||= SQLite3::Database.new(DB_PATH)
  end

  def self.create(title, author, isbn)
    db.execute("INSERT INTO books (title, author, isbn, available) VALUES (?, ?, ?, 1)", [title, author, isbn])
    find_by_isbn(isbn)
  end

  def self.find_by_isbn(isbn)
    row = db.execute("SELECT id, title, author, isbn, available FROM books WHERE isbn = ?", [isbn]).first
    row ? Book.new(id: row[0], title: row[1], author: row[2], isbn: row[3], available: row[4] == 1) : nil
  end

  def self.all
    db.execute("SELECT id, title, author, isbn, available FROM books").map do |row|
      Book.new(id: row[0], title: row[1], author: row[2], isbn: row[3], available: row[4] == 1)
    end
  end

  def available?
    row = self.class.db.execute("SELECT available FROM books WHERE id = ?", [@id]).first
    row && row[0] == 1
  end

  def check_out
    if available?
      self.class.db.execute("UPDATE books SET available = 0 WHERE id = ?", [@id])
      puts "#{@title} has been checked out."
    else
      puts "Error: '#{@title}' is already checked out."
    end
  end

  def return_book
    if !available?
      self.class.db.execute("UPDATE books SET available = 1 WHERE id = ?", [@id])
      puts "#{@title} has been returned."
    else
      puts "Error: '#{@title}' is already marked as available."
    end
  end

  def to_s
    status = available? ? "Available" : "Checked out"
    "#{@title} by #{author} (ISBN: #{isbn}) - #{status}"
  end
end