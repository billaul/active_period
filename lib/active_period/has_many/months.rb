module ActivePeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the months of
    # the FreePeriod
    module Months
      include ActivePeriod::HasMany

      def months
        @months ||= ActivePeriod::Collection.new(ActivePeriod::Month, self)
      end
    end
  end
end
