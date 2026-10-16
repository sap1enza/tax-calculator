# frozen_string_literal: true

module Tax
  module Sales
    module Objects
      Receipt = Data.define(:order) do
        def items = order.items

        def sales_taxes
          items.sum(BigDecimal("0"), &:tax)
        end

        def total
          items.sum(BigDecimal("0"), &:total)
        end
      end
    end
  end
end
