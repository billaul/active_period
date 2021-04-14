module ActivePeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the years of
    # the FreePeriod
    module Years
      include ActivePeriod::HasMany

      def years
        @years ||= itterate(to, ActivePeriod::Month)
      end
    end
  end
end
