class BookshelfService
  attr_reader :filter
  attr_reader :uid

  def initialize(filter=nil, uid=nil)
    @filter = filter
    @uid = uid
  end

  def call
    return unless @filter.present?
    Book.send(@filter.to_sym, @uid)
  end
end

