module ActivePeriod
  module Collection
    class FreePeriod
      include ActivePeriod::Collection

      private

      def enumerator
        raise RangeError.new "cannot get the first element of beginless range" if period.beginless?

        Enumerator.new do |yielder|
          current = klass.new(period.begin)
          while period.calculated_end.nil? || period.include?(current.begin) || period.include?(current.calculated_end)
            yielder << current
            current = current.next
          end
          # At the end (if there is one) the Collection will be return
          self
        end
      end

      def reverse_enumerator
        raise RangeError.new "cannot get the last element of endless range" if period.endless?

        Enumerator.new do |yielder|
          current = klass.new(period.calculated_end)
          while period.begin.nil? || period.include?(current.begin) || period.include?(current.calculated_end)
            yielder << current
            current = current.prev
          end
          # At the end (if there is one) the Collection will be return
          self
        end
      end
    end
  end
end
