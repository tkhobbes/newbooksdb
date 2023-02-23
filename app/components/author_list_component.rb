# frozen_string_literal: true

class AuthorListComponent < ViewComponent::Base

  def initialize(book:, type:)
    @book = book
    @authors = book.authors
    @type = type
    super
  end

  def all_authors(css_classes)
    return if @authors.blank?
    safe_join(
      @authors.map do |author|
        link_to(author.display_name, author, class: css_classes)
      end,
      ', '
    )
  end

  def one_author(css_classes)
    return if @authors.blank?
      link_to(
        @authors.first.display_name, @authors.first, class: css_classes
      ) << (@authors.count > 1 ? ' et al.' : '')
  end

  def by_authors
    return if @authors.blank?
    "(by #{@authors.first.display_name}#{@authors.count > 1 ? ' et al.' : ''})"
  end

end
