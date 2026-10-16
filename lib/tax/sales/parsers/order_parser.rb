# frozen_string_literal: true

module Tax
  module Sales
    module Parsers
      module OrderParser
        module_function

        def call(rows)
          items = rows.each.with_index(2).map do |row, line|
            OrderItemParser.call(row)
          rescue ArgumentError, TypeError, KeyError => e
            raise ArgumentError, "Line #{line}: #{e.message}"
          end

          { items: }
        end
      end
    end
  end
end
