# frozen_string_literal: true

module Tax
  module Sales
    module Objects
      ProductCategory = Data.define(:id, :name, :basic_sales_tax_exempt) do
        alias_method :basic_sales_tax_exempt?, :basic_sales_tax_exempt
      end
    end
  end
end
