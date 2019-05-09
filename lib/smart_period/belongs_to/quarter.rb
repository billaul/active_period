# @author Lucas Billaudot <billau_l@modulotech.fr>
# @note when include this module provide access to the quarter of the SmartPeriod
module SmartPeriod::BelongsTo::Quarter
  def quarter
    SmartPeriod::Quarter.new(from)
  end
end
