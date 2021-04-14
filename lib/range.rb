class Range

  # @return [ActivePeriod::FreePeriod] a new free period
  # @raise see ActivePeriod::FreePeriod.new
  def to_period
    ::Period.new(self)
  end
end
