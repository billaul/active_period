# @author Lucas Billaudot <billau_l@modulotech.fr>
# @note This module define all period of time, who are include in the current period
module SmartPeriod
  module HasMany
    def itterate(to,klass)
      ret = []
      curr = from
      while curr <= to
        ret << klass.new(curr)
        curr = curr.send("next_#{klass._period}")
      end
      ret
    end
  end
end
