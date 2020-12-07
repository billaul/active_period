module Period
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the years of
    # the FreePeriod
    module Years
      include Period::HasMany

      def years
        @years ||= itterate(to, Period::Month)
      end
    end
  end
end
