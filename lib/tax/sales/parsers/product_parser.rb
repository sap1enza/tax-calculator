# frozen_string_literal: true

module Tax
  module Sales
    module Parsers
      module ProductParser
        module_function

        def call(row)
          {
            id: row.fetch("id"),
            category_id: row.fetch("category_id"),
            name: row.fetch("name"),
            basic_sales_tax_exempt: Types.optional_boolean(row.fetch("basic_sales_tax_exempt")),
            imported: Types.boolean(row.fetch("imported")),
            price: Types.positive_decimal(row.fetch("price"))
          }
        end
      end
    end
  end
end
