# frozen_string_literal: true

class LivingYearsComponent < ViewComponent::Base

  def initialize(author:)
    super
    @born = author.born
    @died = author.died
    @dead = author.dead?
  end

  def living_years
    return unless @born || @died
    if @dead
      @born ? "#{@born} - #{@died}" : "Died #{@died}"
    else
      "Born #{@born}"
    end
  end

end