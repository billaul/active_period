module ActivePeriod
  class Collection
    include Enumerable

    # @!attribute [r] klass
    #   @return [ActivePeriod::StandardPeriod] Any kind of ActivePeriod::StandardPeriod object
    attr_reader :klass

    # @!attribute [r] period
    #   @return [ActivePeriod::FreePeriod] Any kind of ActivePeriod::FreePeriod object
    attr_reader :period

    delegate *%i[
      <=> == included?
      strftime to_s i18n
    ], to: :period

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
        # @TODO geré les absence de debut et de fin
        while period.calculated_end.nil? || current.enumerable_date <= period.calculated_end
          yielder << current if current.enumerable_date.in?(period)
          current = current.next
        end
      end
    end

    def reverse_enumerator
      Enumerator.new do |yielder|
        current = klass.new(period.end)
        # @TODO geré les absence de debut et de fin
        while period.begin.nil? || current.enumerable_date >= period.begin
          yielder << current if current.enumerable_date.in?(period)
          current = current.prev
        end
      end
    end
  end
end
