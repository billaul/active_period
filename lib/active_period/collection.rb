module ActivePeriod
  class Collection
    include Enumerable

    # @!attribute [r] klass
    #   @return [ActivePeriod::StandardPeriod] Any kind of ActivePeriod::StandardPeriod object
    attr_reader :klass

    # @!attribute [r] period
    #   @return [ActivePeriod::FreePeriod] Any kind of ActivePeriod::FreePeriod object
    attr_reader :period

    def initialize(klass, period)
      raise I18n.t(:param_klass_must_be_a_standard_period, scope: %i[period collection]) unless klass.ancestors.include?(ActivePeriod::StandardPeriod)
      raise I18n.t(:param_period_must_be_a_free_period, scope: %i[period collection]) unless period.class.ancestors.include?(ActivePeriod::FreePeriod)

      @klass = klass
      @period = period
    end

    def each(&block)
      block_given? ? enumerator.each(&block) : enumerator
    end

    def reverse_each(&block)
      block_given? ? reverse_enumerator.each(&block) : reverse_enumerator
    end

    private

    def enumerator
      Enumerator.new do |yielder|
        current = klass.new(period.begin)
        while period.calculated_end.nil? || current.enumerable_date <= period.calculated_end
          yielder << current if current.enumerable_date.in?(period)
          current = current.next
        end
        # At the end (if there is one) the Collection will be return
        self
      end
    end

    def reverse_enumerator
      Enumerator.new do |yielder|
        current = klass.new(period.end)
        while period.begin.nil? || current.enumerable_date >= period.begin
          yielder << current if current.enumerable_date.in?(period)
          current = current.prev
        end
        # At the end (if there is one) the Collection will be return
        self
      end
    end
  end
end
