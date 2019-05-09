module SmartPeriod::BelongsTo::Month
  def month
    SmartPeriod::Month.new(from)
  end
end
