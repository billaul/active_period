require_relative "standard_period.rb"
require_relative "has_many.rb"
require_relative "belongs_to.rb"
require_relative "has_many/days.rb"
require_relative "belongs_to/week.rb"
require_relative "belongs_to/month.rb"
require_relative "belongs_to/year.rb"

class SmartPeriod::Week < SmartPeriod::StandardPeriod
  include SmartPeriod::HasMany::Days

  include SmartPeriod::BelongsTo::Month
  include SmartPeriod::BelongsTo::Quarter
  include SmartPeriod::BelongsTo::Year


  def strftime(format)
    self.from.strftime(format)
  end

  def to_s
    self.strftime("Semaine %W - %Y")
  end

end
