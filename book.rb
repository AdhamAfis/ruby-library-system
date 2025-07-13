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
      puts "#{@title} has been checked out."
    else
      puts "Error: '#{@title}' is already checked out."
    end
  end

  # return the book marking it as available
  def return_book
    if !@available
      @available = true
      puts "#{@title} has been returned."
    else
      puts "Error: '#{@title}' is already marked as available."
    end
  end

  # string representation of the book
  def to_s
    status = @available ? "Available" : "Checked out"
    "#{@title} by #{author} (ISBN: #{isbn}) - #{status}"
  end

end