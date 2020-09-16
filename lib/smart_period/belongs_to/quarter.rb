module SmartPeriod
  module BelongsTo
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the quarter of the
    # FreePeriod
    module Quarter
      def quarter
        SmartPeriod::Quarter.new(from)
      end
    end
  end
end
