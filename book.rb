class Book
  attr_accessor :title, :author, :isbn, :available 

  def initialize(title, author, isbn, available)
    @title = title
    @author = author
    @isbn = isbn
    @available = available
  end

  # check out the book marking it as unavailable
  def check_out
    if @available
      @available = false
      puts "#{@title} has been checked out"
    else
      puts "Books doesnt exist"
    end
  end

end