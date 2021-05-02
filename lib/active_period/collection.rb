module ActivePeriod
  module Collection
    include Enumerable

    # @!attribute [r] klass
    #   @return [ActivePeriod::StandardPeriod] Any kind of ActivePeriod::StandardPeriod object
    attr_reader :klass

    # @!attribute [r] period
    #   @return [ActivePeriod::FreePeriod] Any kind of ActivePeriod::FreePeriod object
    attr_reader :period

    def self.new(klass, period)
      if period.is_a? ActivePeriod::StandardPeriod
        ActivePeriod::Collection::StandardPeriod.new(klass, period)
      else
        ActivePeriod::Collection::FreePeriod.new(klass, period)
      end
    end

    def initialize(klass, period)
      raise I18n.t(:param_klass_must_be_a_standard_period, scope: %i[active_period collection]) unless klass.ancestors.include?(ActivePeriod::StandardPeriod)
      raise I18n.t(:param_period_must_be_a_period, scope: %i[active_period collection]) unless period.class.ancestors.include?(ActivePeriod::Period)

      @klass  = klass
      @period = period
    end

    def second
      find_nth(1)
    end

    def third
      find_nth(2)
    end

    def fourth
      find_nth(3)
    end

    def find_nth(limit)
      each.with_index do |element, index|
        return element if index == limit
      end
      return nil
    end

    def each(&block)
      block_given? ? enumerator.each(&block) : enumerator
    end

    def reverse_each(&block)
      block_given? ? reverse_enumerator.each(&block) : reverse_enumerator
    end

    def last
      reverse_each.first
    end

  end
end
