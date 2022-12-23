# frozen_string_literal: true

module IsbnSearchHelper
  # method determines the right CSS for existing books
  def existing_css(existing)
    case existing
    when 'current_owner'
      'existing-current'
    when 'other_owner'
      'existing-other'
    end
  end

  # this method prints out a book title and formats depending on whether existing
  def existing_title(title, existing)
    case existing
    when 'current_owner'
      "#{title} (you already own this book!)"
    when 'other_owner'
      "#{title} (this book is already owned by another user!)"
    else
      title
    end
  end

end
