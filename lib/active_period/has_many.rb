# @author Lucas Billaudot <billau_l@modulotech.fr>
# @note This module define all period of time, who are include in the current period
module ActivePeriod
  module HasMany
    def itterate(to,klass)
      ret = []
      curr = from
      # Handle timezone with to_date
      while curr.to_date <= to.to_date
        ret << klass.new(curr.to_date)
        curr = curr.send("next_#{klass._period}")
      end
      ret
    end
  end
end
