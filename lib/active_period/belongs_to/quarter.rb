module ActivePeriod
  module BelongsTo
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the quarter of the
    # FreePeriod
    module Quarter
      def quarter
        ActivePeriod::Quarter.new(enumerable_date)
      end
    end
  end
end
