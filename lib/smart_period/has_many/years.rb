# @author Lucas Billaudot <billau_l@modulotech.fr>
# @note when include this module provide itterable access to the days of the SmartPeriod
module SmartPeriod::HasMany::Years
  def years
    return @years if @years.present?

    @years = []
    curr = from

    while curr <= to
      @years << SmartPeriod::Year.new(curr)
      curr = curr.next_year
    end

    return @years
  end
end
