# frozen_string_literal: true

# this service class transfers books from one user to another
class BookTransfer
  def initialize(from_user, to_user)
    @from_user = from_user
    @to_user = to_user
  end

  # this method smells of :reek:DuplicateMethodCall
  def transfer
    return ReturnTransfer.new(transferred: false, msg: 'No books to transfer') if @from_user.books.empty?
    return ReturnTransfer.new(transferred: false,
      msg: 'No users to transfer from / to') unless @from_user && @to_user
    @from_user.books.each do |book|
      book.update(owner_id: @to_user.id)
    end
    ReturnTransfer.new(transferred: true, msg: 'Books transferred')
  end

  # this class serves as return object
  class ReturnTransfer
    attr_reader :message

    def initialize(transferred: false, msg: '')
      @transferred = transferred
      @message = msg
    end

    def transferred?
      @transferred
    end

  end

end
