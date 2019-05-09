# @author Lucas Billaudot <billau_l@modulotech.fr>
# @note when include this module provide access to the week of the SmartPeriod
module SmartPeriod::BelongsTo::Week
  def week
    SmartPeriod::Week.new(from)
  end
end
