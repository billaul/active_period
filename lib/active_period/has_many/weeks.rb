module ActivePeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the weeks of
    # the FreePeriod
    module Weeks
      def weeks
        @weeks ||= []
        return @weeks if @weeks.present?
        curr = from
        while curr <= to
          week = ActivePeriod::Week.new(curr)
          @weeks << week if week.iso_date.in?(self)
          curr = curr.next_week
        end

        @weeks
      end

    end
  end
end
