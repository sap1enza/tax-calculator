# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Objects
      class OrderItemTest < Minitest::Test
        def test_exposes_its_attributes
          product = build_product
          item = OrderItem.new(product:, quantity: 3)

          assert_same product, item.product
          assert_equal 3, item.quantity
        end

        def test_requires_every_attribute
          assert_raises(ArgumentError) { OrderItem.new(quantity: 1) }
        end

        def test_is_immutable
          assert_predicate build_order_item, :frozen?
        end

        def test_unit_tax_is_the_tax_for_one_unit
          item = build_order_item(product: taxed_product("14.99"), quantity: 2)

          assert_equal BigDecimal("1.50"), item.unit_tax
        end

        def test_tax_multiplies_the_rounded_unit_tax_by_quantity
          item = build_order_item(product: taxed_product("11.25", imported: true), quantity: 3)

          assert_equal BigDecimal("5.10"), item.tax
        end

        def test_total_is_price_times_quantity_plus_tax
          item = build_order_item(product: taxed_product("12.49", basic_sales_tax_exempt: true), quantity: 2)

          assert_equal BigDecimal("24.98"), item.total
        end

        def test_exempt_local_product_has_no_tax
          item = build_order_item(product: taxed_product("0.85", basic_sales_tax_exempt: true))

          assert_equal BigDecimal("0"), item.tax
          assert_equal BigDecimal("0.85"), item.total
        end

        private

        def taxed_product(price, basic_sales_tax_exempt: false, imported: false)
          build_product(price: BigDecimal(price), basic_sales_tax_exempt:, imported:)
        end
      end
    end
  end
end
