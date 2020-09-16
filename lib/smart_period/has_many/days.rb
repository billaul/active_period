module SmartPeriod::HasMany::Days
  def days
    return @days if @days.present?

    @days = []
    curr = from
    while curr <= to
      @days << SmartPeriod::Day.new(curr)
      curr = curr.next_day
    end

    @days
  end
end
