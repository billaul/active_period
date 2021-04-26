module ActivePeriod
  module BelongsTo
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the year of the
    # FreePeriod
    module Year
      def year
        ActivePeriod::Year.new(self.begin)
      end
    end
  end
end
