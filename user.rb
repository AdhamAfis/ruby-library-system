class User
  attr_reader :name, :id

  def initialize (name, id , borrowed_books)
    @name = name
    @id = id 
    @borrowed_books = borrowed_books
  end

  # borrow a book if available or notify the user if not
  def borrow_book(book)
    if book.available
      book.check_out
      @borrowed_books << book
      puts "#{@name} has borrowed #{book.title}"
    else
      puts "Error: #{book.title} is not available for borrowing"
    end
  end
  # return a book if it was borrowed by the user or notify the user if not  
  def return_book(book)
    if @borrowed_books.include?(book)
      book.return_book
      @borrowed_books.delete(book)
      puts "#{@name} has returned #{book.title}"
    else
      puts "Error: #{@name} does not have #{book.title} borrowed"
    end
  end

  # list all borrowed books for the user
  def list_borrowed_books
    if @borrowed_books.empty?
      puts "#{@name} has no borrowed books"
    else
      puts "#{@name}'s borrowed books:"
      @borrowed_books.each { |book| puts book.title }
    end
  end
end