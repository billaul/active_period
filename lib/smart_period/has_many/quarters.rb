module SmartPeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the quarters of
    # the FreePeriod
    module Quarters
      include SmartPeriod::HasMany

      def quarters
        @quarters ||= itterate(to, SmartPeriod::Quarter)
      end
    end
  end
end
