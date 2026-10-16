# frozen_string_literal: true

module Tax
  module Sales
    module Basic
      module_function

      def rate = 10

      def applies_to?(product)
        !product.basic_sales_tax_exempt?
      end
    end
  end
end
