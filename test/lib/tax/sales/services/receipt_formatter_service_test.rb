# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Services
      class ReceiptFormatterServiceTest < Minitest::Test
        def test_lists_each_item_then_sales_taxes_and_total
          items = [
            build_order_item(product: product("book", "12.49", basic_sales_tax_exempt: true), quantity: 2),
            build_order_item(product: product("music CD", "14.99"), quantity: 1),
            build_order_item(product: product("chocolate bar", "0.85", basic_sales_tax_exempt: true), quantity: 1)
          ]

          expected = <<~RECEIPT.chomp
            2 book: 24.98
            1 music CD: 16.49
            1 chocolate bar: 0.85
            Sales Taxes: 1.50
            Total: 42.32
          RECEIPT

          assert_equal expected, ReceiptFormatterService.call(receipt(items))
        end

        def test_formats_money_with_two_decimals
          output = ReceiptFormatterService.call(receipt([build_order_item(product: product("thing", "10"))]))

          assert_equal "1 thing: 11.00\nSales Taxes: 1.00\nTotal: 11.00", output
        end

        def test_formats_an_empty_receipt
          assert_equal "Sales Taxes: 0.00\nTotal: 0.00", ReceiptFormatterService.call(receipt([]))
        end

        private

        def receipt(items)
          Objects::Receipt.new(order: Objects::Order.new(items:))
        end

        def product(name, price, basic_sales_tax_exempt: false, imported: false)
          build_product(name:, price: BigDecimal(price), basic_sales_tax_exempt:, imported:)
        end
      end
    end
  end
end
