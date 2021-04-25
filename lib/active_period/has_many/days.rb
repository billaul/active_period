module ActivePeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the days of the
    # FreePeriod
    module Days
      include ActivePeriod::HasMany

      def days
        @days ||= ActivePeriod::Collection.new(ActivePeriod::Day, self)
      end
    end
  end
end
