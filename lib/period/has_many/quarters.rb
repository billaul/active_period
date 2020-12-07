module Period
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the quarters of
    # the FreePeriod
    module Quarters
      include Period::HasMany

      def quarters
        @quarters ||= itterate(to, Period::Quarter)
      end
    end
  end
end
