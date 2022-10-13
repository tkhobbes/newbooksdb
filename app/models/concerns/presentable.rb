# This is an abstract class using Ruby metaprogramming to dynamically
# define a presenter class with enforced naming conventions.
# taken from https://pawelurbanek.com/rails-presenter-pattern

module Presentable
  def decorate
    "#{self.class}Presenter".constantize.new(self)
  end
end
