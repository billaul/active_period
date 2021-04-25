module ActivePeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the weeks of
    # the FreePeriod
    module Weeks
      include ActivePeriod::HasMany

      def weeks
        @quarters ||= ActivePeriod::Collection.new(ActivePeriod::Week, self)
      end

    end
  end
end
