class Library
  
  def initialize(books, users)
    @books = books
    @users = users
  end


  def add_book(book)
    @books << book
    puts "#{book.title} has been added"
  end

  def remove_book(isbn)
    book = @books.find { |b| b.isbn == isbn }
    if book
      @books.delete(book)
      puts "Book with ISBN #{isbn} has been removed"
    else
      puts "Error: Book with ISBN #{isbn} does not exist."
    end
  end

  # searches for books by title and optionally by author prints matching books and return them in array
  def search_books(title, author = nil)
    results = @books.select do |book|
      book.title.downcase.include?(title.downcase) && (author.nil?||book.author.downcase.include?(author.downcase))
    end
    results.each { |book| puts "#{book.title} by #{book.author}" }
    results
  end

  def register_user(user)
    @users << user
    puts "#{user.name} has been registered"
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