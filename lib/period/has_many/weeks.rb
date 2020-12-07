module Period
  module HasMany
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide itterable access to the weeks of
    # the FreePeriod
    module Weeks
      # TODO, rewrite this to respect ISO %V %G
      def weeks
        @weeks ||= []
        return @weeks if @weeks.present?
        curr = from
        while curr <= to
          week = Period::Week.new(curr)
          @weeks << week if week.iso_date.in?(self)
          curr = curr.next_week
        end

        @weeks
      end

    end
  end
end
