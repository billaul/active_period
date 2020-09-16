# @author Lucas Billaudot <billau_l@modulotech.fr>
# @note when include this module provide itterable access to the days of the SmartPeriod
module SmartPeriod::HasMany::Quarters
  def quarters
    return @quarters if @quarters.present?

    @quarters = []
    curr = from
    while curr <= to
      @quarters << SmartPeriod::Quarter.new(curr)
      curr = curr.next_quarter
    end

    @quarters
  end
end
