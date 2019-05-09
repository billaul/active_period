require_relative "standard_period.rb"
require_relative "has_many.rb"
require_relative "has_many/days.rb"
require_relative "has_many/weeks.rb"
require_relative "has_many/months.rb"
require_relative "belongs_to.rb"
require_relative "belongs_to/year.rb"

class SmartPeriod::Quarter < SmartPeriod::StandardPeriod
  include SmartPeriod::HasMany::Days
  include SmartPeriod::HasMany::Weeks
  include SmartPeriod::HasMany::Months

  include SmartPeriod::BelongsTo::Year

  def strftime(format)
    format = format.gsub(":quarter", self.quarter_nb.to_s)
    self.from.strftime(format)
  end

  def quarter_nb
    @quarter_nb ||= (self.from.month / 3.0).ceil
  end

  # @todo i18n
  def to_s
    self.strftime("Trimestre :quarter - %Y")
  end

  def i18n(format:)
    I18n.l(from, format: format)
  end

end
