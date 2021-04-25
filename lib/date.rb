require "date"

class Date
  # @see https://bugs.ruby-lang.org/issues/17825
  INFINITY = Date::Infinity.new.freeze
end
