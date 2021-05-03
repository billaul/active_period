module ActivePeriod
  module Collection
    class StandardPeriod
      include ActivePeriod::Collection

      private

      def enumerator
        Enumerator.new do |yielder|
          current = klass.new(period.begin)
          while current.calculated_end <= period.calculated_end || period.include?(current)
            yielder << current if period.include?(current)
            current = current.next
          end
          # At the end (if there is one) the Collection will be return
          self
        end
      end

      def reverse_enumerator
        Enumerator.new do |yielder|
          current = klass.new(period.calculated_end)
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
