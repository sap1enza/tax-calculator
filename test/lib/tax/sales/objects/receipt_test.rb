# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Objects
      class ReceiptTest < Minitest::Test
        Item = Data.define(:tax, :total)

        def test_exposes_the_order_and_its_items
          order = Order.new(items: [item(tax: "1.00", total: "11.00")])
          receipt = Receipt.new(order:)

          assert_same order, receipt.order
          assert_equal order.items, receipt.items
        end

        def test_is_immutable
          assert_predicate receipt_with, :frozen?
        end

        def test_empty_receipt_totals_are_zero
          assert_equal BigDecimal("0"), receipt_with.sales_taxes
          assert_equal BigDecimal("0"), receipt_with.total
        end

        def test_sales_taxes_sums_the_tax_of_every_item
          receipt = receipt_with(item(tax: "1.50", total: "16.49"), item(tax: "0", total: "0.85"))

          assert_equal BigDecimal("1.50"), receipt.sales_taxes
        end

        def test_total_sums_the_total_of_every_item
          receipt = receipt_with(item(tax: "1.50", total: "16.49"), item(tax: "0", total: "0.85"))

          assert_equal BigDecimal("17.34"), receipt.total
        end

        def test_totals_are_big_decimals
          receipt = receipt_with(item(tax: "1.00", total: "11.00"))

          assert_kind_of BigDecimal, receipt.sales_taxes
          assert_kind_of BigDecimal, receipt.total
        end

        private

        def receipt_with(*items)
          Receipt.new(order: Order.new(items:))
        end

        def item(tax:, total:)
          Item.new(tax: BigDecimal(tax), total: BigDecimal(total))
        end
      end
    end
  end
end
