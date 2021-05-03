# This module is intended to hide the complexity of ActivePeriod
# And permit the user to write less and doing more
module Period

  # Shorthand to ActivePeriod::FreePeriod.new
  def self.new(*args)
    ActivePeriod::FreePeriod.new(*args)
  end

  # Shorthand ActivePeriod::FreePeriod.new(range, allow_beginless: false, allow_endless: false)
  def self.bounded(range)
    ActivePeriod::FreePeriod.new(range, allow_beginless: false, allow_endless: false)
  end

  # env_time provide a Fallback if the project dont specify any Time.zone
  def self.env_time
    (Time.zone || Time)
  end

  # Dynamic definition of `.(last|this|next)_(day|week|month|quarter|year)`
  # and `.yesterday` `.today` `.tomorrow`
  # TODO implement (last|next)_holiday
  class << self
    %i[day week month quarter year].each do |standard_period|
      define_method "last_#{standard_period}" do
        date = env_time.now.send(standard_period == :day ? 'yesterday' : "last_#{standard_period}")
        Object.const_get("ActivePeriod::#{standard_period.capitalize}").new(date)
      end

      define_method "this_#{standard_period}" do
        Object.const_get("ActivePeriod::#{standard_period.capitalize}").new(env_time.now)
      end

      define_method "next_#{standard_period}" do
        date = env_time.now.send(standard_period == :day ? 'tomorrow' : "next_#{standard_period}")
        Object.const_get("ActivePeriod::#{standard_period.capitalize}").new(date)
      end

      define_method standard_period.to_s do |range|
        Object.const_get("ActivePeriod::#{standard_period.capitalize}").new(range)
      end
    end

    alias yesterday last_day
    alias tomorrow next_day
    alias today this_day

    # Experimental non-documented feature
    # Inpired form ActiveRecord dynamic find_by_x like User.find_by_name
    # Example: Period.last_3_weeks_from_now == Period.mew(2.weeks.ago.beginning_of_week..Time.now.end_of_week)
    # Note : Maybe it should return a collection of StandardPeriod
    def method_missing(method_name, *arguments, &block)
      super unless method_name.match?(/(last|next)_\d+_(day|week|month|quarter|year)s?(_from_now)?/)
      last_next, count, klass = method_name.to_s.split('_')
      klass = klass.singularize

      case last_next
      when 'last'
        from = count.to_i.send(klass).ago.send("beginning_of_#{klass}")
        to = env_time.now
        to -= 1.send(klass) unless method_name.match?(/from_now$/)
        to = to.send("end_of_#{klass}")
      when 'next'
        from = env_time.now
        from += 1.send(klass) unless method_name.match?(/from_now$/)
        from = from.send("beginning_of_#{klass}")
        to = count.to_i.send(klass).from_now.send("end_of_#{klass}")
      end
      self.new(from..to)
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.match?(/(last|next)_\d+_(day|week|month|quarter|year)s?(_from_now)?/) || super
    end
  end
end
