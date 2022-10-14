# frozen_string_literal: true

# Decorator / presenter methods for authors
# methods can be called with @author.decorate.method_name
class AuthorPresenter < SimpleDelegator
  include ActionView::Helpers
  include InlineSvg::ActionView::Helpers # for the icons

  # shows either a male or a female icon (or none), dependent on the gender
  def gender_icon
    return if gender.blank?
    if gender == 'male'
      inline_svg_tag('male.svg', class: 'smallicon')
    else
      inline_svg_tag('female.svg', class: 'smallicon')
    end
  end

  # returns the birth and dead year if dead, otherwise just the birth year
  # this method smells of :reek:DuplicateMethodCall
  def living_years
    return unless born || died
    if dead?
      born ? "#{born} - #{died}" : "Died #{died}"
    else
      "Born #{born}"
    end
  end
end
