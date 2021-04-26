module ActivePeriod
  module Collection
    class StandardPeriod
      include ActivePeriod::Collection

      private

      def enumerator
        raise RangeError.new "cannot get the first element of beginless range" if period.beginless?

        Enumerator.new do |yielder|
          current = klass.new(period.begin)
          while current.end <= period.end || period.include?(current)
            yielder << current if period.include?(current)
            current = current.next
          end
          # At the end (if there is one) the Collection will be return
          self
        end
      end

      def reverse_enumerator
        raise RangeError.new "cannot get the last element of endless range" if period.endless?

        Enumerator.new do |yielder|
          current = klass.new(period.end)
          while current.begin <= period.begin || period.include?(current)
            yielder << current if period.include?(current)
            current = current.prev
          end
          # At the end (if there is one) the Collection will be return
          self
        end
      end
    end
  end
end
