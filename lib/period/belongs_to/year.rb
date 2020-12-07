module Period
  module BelongsTo
    # @author Lucas Billaudot <billau_l@modulotech.fr>
    # @note when include this module provide access to the year of the
    # FreePeriod
    module Year
      def year
        Period::Year.new(iso_date)
      end
    end
  end
end
