module Period
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the days of the
    # FreePeriod
    module Days
      include Period::HasMany

      def days
        @days ||= itterate(to, Period::Day)
      end
    end
  end
end
