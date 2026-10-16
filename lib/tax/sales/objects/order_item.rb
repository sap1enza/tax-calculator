# frozen_string_literal: true

module Tax
  module Sales
    module Objects
      OrderItem = Data.define(:product, :quantity) do
        def unit_tax
          Services::CalculatorService.call(product)
        end

        def tax
          unit_tax * quantity
        end

        def total
          product.price * quantity + tax
        end
      end
    end
  end
end
