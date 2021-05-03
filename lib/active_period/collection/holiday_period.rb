module ActivePeriod
  module Collection
    class HolidayPeriod
      include ActivePeriod::Collection

      # @!attribute [r] options
      #   @return [Array] The array of options for Holidays.on
      attr_reader :options

      def initialize(klass, period, *args)
        super(klass, period)
        @options = args
      end

      private

      def enumerator
        Enumerator.new do |yielder|
          days = period.try(:days) || [period]
          days.each do |day|
            Holidays.on(day.begin.to_date, *options).each do |hash|
              yielder << ActivePeriod::Holiday.new(**hash, options: @options)
            end
          end
          # At the end (if there is one) the Collection will be return
          self
        end
      end

      def reverse_enumerator
        Enumerator.new do |yielder|
          days = period.try(:days) || [period]
          days.reverse_each do |day|
            Holidays.on(day.begin.to_date, *options).each do |hash|
              yielder << ActivePeriod::Holiday.new(**hash, options: @options)
            end
          end
          # At the end (if there is one) the Collection will be return
          self
        end
      end
    end
  end
end
