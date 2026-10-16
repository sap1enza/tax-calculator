# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Services
      class CalculatorServiceTest < Minitest::Test
        def test_basic_sales_tax_at_ten_percent
          assert_equal BigDecimal("1.50"), tax_for("14.99")
        end

        def test_no_tax_for_an_exempt_local_product
          assert_equal BigDecimal("0"), tax_for("12.49", basic_sales_tax_exempt: true)
        end

        def test_import_duty_only_for_an_exempt_imported_product
          assert_equal BigDecimal("0.50"), tax_for("10.00", basic_sales_tax_exempt: true, imported: true)
        end

        def test_combined_rate_for_a_taxable_imported_product
          assert_equal BigDecimal("7.15"), tax_for("47.50", imported: true)
        end

        def test_rounds_up_to_the_nearest_five_cents
          assert_equal BigDecimal("4.20"), tax_for("27.99", imported: true)
          assert_equal BigDecimal("1.90"), tax_for("18.99")
        end

        def test_does_not_round_an_exact_multiple_of_five_cents
          assert_equal BigDecimal("1.00"), tax_for("10.00")
        end

        def test_returns_a_big_decimal
          assert_kind_of BigDecimal, tax_for("1.00")
        end

        def test_is_deterministic
          product = build_product(price: BigDecimal("47.50"), imported: true)

          assert_equal CalculatorService.call(product), CalculatorService.call(product)
        end

        private

        def tax_for(price, basic_sales_tax_exempt: false, imported: false)
          CalculatorService.call(build_product(price: BigDecimal(price), basic_sales_tax_exempt:, imported:))
        end
      end
    end
  end
end
