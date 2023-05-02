# frozen_string_literal: true

# this component contains methods to show authors of a book in different ways
# this class smells of :reek:RepeatedConditional
class AuthorListComponent < ViewComponent::Base

  def initialize(book:, type:)
    @book = book
    @authors = book.authors
    @type = type
    super
  end

  # show all authors of a book, joined by commas
  def all_authors(css_classes)
    return if @authors.blank?
    safe_join(
      @authors.map do |author|
        link_to(author.display_name, author, class: css_classes)
      end,
      ', '
    )
  end

  # show the first author and append "et al." if there are more
  # this method smells of :reek:DuplicateMethodCall
  def one_author(css_classes)
    return if @authors.blank?
      link_to(
        @authors.first.display_name, @authors.first, class: css_classes
      ) << (@authors.count > 1 ? ' et al.' : '')
  end

  # shows (by ...) for the first author and adds "et al." if there are more than one
  def by_authors
    return if @authors.blank?
    "(#{t('AuthorListComponent.by', author: @authors.first.display_name)}\
    #{@authors.count > 1 ? t('AuthorListComponent.more') : ''})"
  end

end
