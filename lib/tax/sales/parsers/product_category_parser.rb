# frozen_string_literal: true

module Tax
  module Sales
    module Parsers
      module ProductCategoryParser
        module_function

        def call(row)
          {
            id: row.fetch("id"),
            name: row.fetch("name"),
            basic_sales_tax_exempt: Types.boolean(row.fetch("basic_sales_tax_exempt"))
          }
        end
      end
    end
  end
end
