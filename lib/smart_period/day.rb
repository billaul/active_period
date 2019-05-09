require_relative "standard_period.rb"
require_relative "belong_to/day.rb"
require_relative "belong_to/week.rb"
require_relative "belong_to/month.rb"
require_relative "belong_to/year.rb"

class SmartPeriod::Day < SmartPeriod::StandardPeriod
  include SmartPeriod::BelongsTo::Week
  include SmartPeriod::BelongsTo::Month
  include SmartPeriod::BelongsTo::Quarter
  include SmartPeriod::BelongsTo::Year

  def strftime(format)
    self.from.strftime(format)
  end

  def to_s
    self.strftime("%d/%m/%Y")
  end

end
