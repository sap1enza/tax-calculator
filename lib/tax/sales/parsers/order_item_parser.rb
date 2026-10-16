# frozen_string_literal: true

module Tax
  module Sales
    module Parsers
      module OrderItemParser
        module_function

        def call(row)
          {
            product_id: row.fetch("product_id"),
            quantity: Types.positive_integer(row.fetch("quantity"))
          }
        end
      end
    end
  end
end
