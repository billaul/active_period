module ActivePeriod
  module BelongsTo
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the year of the
    # FreePeriod
    module Year
      def year
        ActivePeriod::Year.new(enumerable_date)
      end
    end
  end
end
