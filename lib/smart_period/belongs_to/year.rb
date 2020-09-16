module SmartPeriod
  module BelongsTo
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the year of the
    # FreePeriod
    module Year
      def year
        SmartPeriod::Year.new(from)
      end
    end
  end
end
