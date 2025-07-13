# frozen_string_literal: true

require 'sqlite3'

db = SQLite3::Database.new 'library.db'

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    isbn TEXT UNIQUE NOT NULL,
    available INTEGER NOT NULL DEFAULT 1
  );
SQL

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
  );
SQL

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS borrowed_books (
    user_id INTEGER,
    book_id INTEGER,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(book_id) REFERENCES books(id)
  );
SQL
