# frozen_string_literal: true

class GenderIconComponent < ViewComponent::Base

  def initialize(author:)
    super
    @gender = author.gender
  end

  def gender_icon
    return if @gender.blank?
    if @gender == 'male'
      inline_svg_tag('male.svg', class: 'smallicon')
    else
      inline_svg_tag('female.svg', class: 'smallicon')
    end
  end

end
