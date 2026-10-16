# frozen_string_literal: true

module Tax
  module Sales
    module ImportDuty
      module_function

      def rate = 5

      def applies_to?(product)
        product.imported?
      end
    end
  end
end
