module ActivePeriod
  module BelongsTo
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the month of the
    # FreePeriod
    module Month
      def month
        ActivePeriod::Month.new(iso_date)
      end
    end
  end
end
