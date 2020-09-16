# @author Lucas Billaudot <billau_l@modulotech.fr>
# @note when include this module provide itterable access to the days of the SmartPeriod
module SmartPeriod::HasMany::Months
  def months
    return @months if @months.present?

    @months = []
    curr = from
    while curr <= to
      @months << SmartPeriod::Month.new(curr)
      curr = curr.next_month
    end

    @months
  end
end
