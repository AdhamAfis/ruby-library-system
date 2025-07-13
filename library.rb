class Library
  
  def initialize(books, users)
    @books = books
    @users = users
  end


  def add_book(book)
    if @books.any? { |b| b.isbn == book.isbn }
      puts "Error: Book with ISBN #{book.isbn} already exists."
    else
      @books << book
      puts "#{book.title} has been added"
    end
  end

  def remove_book(isbn)
    book = @books.find { |b| b.isbn == isbn }
    if book
      if !book.available
        puts "Error: Cannot remove '#{book.title}' because it is currently checked out."
      else
        @books.delete(book)
        puts "Book with ISBN #{isbn} has been removed"
      end
    else
      puts "Error: Book with ISBN #{isbn} does not exist."
    end
  end

  # searches for books by title and optionally by author prints matching books and return them in array
  def search_books(title, author = nil)
    if title.strip.empty? && (author.nil? || author.strip.empty?)
      puts "Error: Please provide a title or author to search."
      return []
    end
    results = @books.select do |book|
      (title.strip.empty? || book.title.downcase.include?(title.downcase)) &&
      (author.nil? || author.strip.empty? || book.author.downcase.include?(author.downcase))
    end
    if results.empty?
      puts "No books found matching your search."
    else
      results.each { |book| puts "#{book.title} by #{book.author}" }
    end
    results
  end

  def register_user(user)
    if @users.any? { |u| u.id == user.id }
      puts "Error: User ID #{user.id} already exists."
    else
      @users << user
      puts "#{user.name} has been registered"
    end
  end
  # lends a book to a user by their IDs calls the user's borrow_book method if both user and book are found
  def lend_book(user_id, isbn)
    user = @users.find { |u| u.id == user_id }
    book = @books.find { |b| b.isbn == isbn }
    if !user
      puts "Error: User with ID #{user_id} not found."
    elsif !book
      puts "Error: Book with ISBN #{isbn} not found."
    elsif !book.available
      puts "Error: '#{book.title}' is not available for lending."
    elsif user.instance_variable_get(:@borrowed_books).include?(book)
      puts "Error: User already borrowed '#{book.title}'."
    else
      user.borrow_book(book)
    end
  end

  # receives a book from a user by their IDs calls the user's return_book method if both user and book are found
  def receive_book(user_id, isbn)
    user = @users.find { |u| u.id == user_id }
    book = @books.find { |b| b.isbn == isbn }
    if !user
      puts "Error: User with ID #{user_id} not found."
    elsif !book
      puts "Error: Book with ISBN #{isbn} not found."
    else
      user.return_book(book)
    end
  end
end