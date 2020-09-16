module SmartPeriod
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the weeks of
    # the FreePeriod
    module Weeks
      # TODO, rewrite this to respect ISO %V %G
      def weeks
        return @weeks if @weeks.present?

        @weeks = []
        curr =
          if from.beginning_of_week.month == from.month
            from
          else
            from.next_week
          end

        while curr <= to
          @weeks << SmartPeriod::Week.new(curr)
          curr = curr.next_week
        end

        @weeks
      end
    end
  end
end
