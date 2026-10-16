# frozen_string_literal: true

module Tax
  module Sales
    module Objects
      Product = Data.define(:id, :name, :category, :basic_sales_tax_exempt, :imported, :price) do
        alias_method :imported?, :imported

        def basic_sales_tax_exempt?
          basic_sales_tax_exempt.nil? ? category.basic_sales_tax_exempt? : basic_sales_tax_exempt
        end
      end
    end
  end
end
