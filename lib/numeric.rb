class Numeric
  def quarters
    ActiveSupport::Duration.months(self * 3)
  end
  alias :quarter :quarters
end
