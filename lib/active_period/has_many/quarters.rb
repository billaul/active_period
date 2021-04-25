module ActivePeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the quarters of
    # the FreePeriod
    module Quarters
      include ActivePeriod::HasMany

      def quarters
        @quarters ||= ActivePeriod::Collection.new(ActivePeriod::Quarter, self)
      end
    end
  end
end
