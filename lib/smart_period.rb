require "smart_period/version"
require "active_support/all"
require "i18n"

require_relative "smart_period/period_range.rb"
require_relative "smart_period/day.rb"
require_relative "smart_period/week.rb"
require_relative "smart_period/month.rb"
require_relative "smart_period/quarter.rb"
require_relative "smart_period/year.rb"

module SmartPeriod

  def self.new(range)
    SmartPeriod::PeriodRange.new(range)
  end

  class << self
    %i(day week month quarter year).each do |period|
      define_method "last_#{period}" do
        date = (Time.zone || Time).now.send(period == :day ? 'yesterday' : "last_#{period}")
        Object.const_get("SmartPeriod::#{period.capitalize}").new(date)
      end

      define_method "this_#{period}" do
        Object.const_get("SmartPeriod::#{period.capitalize}").new((Time.zone || Time).now)
      end

      define_method "next_#{period}" do
        date = (Time.zone || Time).now.send(period == :day ? 'tomorrow' : "next_#{period}")
        Object.const_get("SmartPeriod::#{period.capitalize}").new(date)
      end

      define_method "#{period}" do
        Object.const_get("SmartPeriod::#{period.capitalize}")
      end
    end

    alias_method :yesterday, :last_day
    alias_method :tomorrow, :next_day
    alias_method :today, :this_day
  end

end
