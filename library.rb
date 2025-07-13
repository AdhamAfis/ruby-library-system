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
    @books.reject! { |book| book.isbn == isbn }
    puts "Book with ISBN #{isbn} has been removed"
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
    
    if user && book
      user.borrow_book(book)
    else
      puts "User or book not found"
    end
  end

  # receives a book from a user by their IDs calls the user's return_book method if both user and book are found
  def receive_book(user_id, isbn)
    user = @users.find { |u| u.id == user_id }
    book = @books.find { |b| b.isbn == isbn }
    
    if user && book
      user.return_book(book)
    else
      puts "User or book not found"
    end
  end
end