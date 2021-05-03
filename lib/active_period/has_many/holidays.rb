module ActivePeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the holidays of the
    # FreePeriod
    module Holidays
      include ActivePeriod::HasMany

      def holidays(*args, &block)
        raise I18n.t(:gem_require, scope: %i[active_period holiday_period]) unless Object.const_defined?('Holidays')
        ActivePeriod::Collection::HolidayPeriod.new(ActivePeriod::Holiday, self, *args, &block)
      end
    end
  end
end
