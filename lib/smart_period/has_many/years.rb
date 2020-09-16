module SmartPeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the years of
    # the FreePeriod
    module Years
      include SmartPeriod::HasMany

      def years
        @years ||= itterate(to, SmartPeriod::Month)
      end
    end
  end
end
