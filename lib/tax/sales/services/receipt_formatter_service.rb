# frozen_string_literal: true

module Tax
  module Sales
    module Services
      class ReceiptFormatterService
        def self.call(...) = new(...).call

        def initialize(receipt)
          @receipt = receipt
        end

        def call
          lines = @receipt.items.map { |item| "#{item.quantity} #{item.product.name}: #{money(item.total)}" }
          lines << "Sales Taxes: #{money(@receipt.sales_taxes)}"
          lines << "Total: #{money(@receipt.total)}"
          lines.join("\n")
        end

        private

        def money(amount)
          format("%.2f", amount)
        end
      end
    end
  end
end
