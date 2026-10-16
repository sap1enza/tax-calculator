# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    class BasicTest < Minitest::Test
      def test_rate_is_ten_percent
        assert_equal 10, Basic.rate
      end

      def test_applies_to_a_taxable_product
        assert Basic.applies_to?(build_product)
      end

      def test_does_not_apply_to_an_exempt_product
        refute Basic.applies_to?(build_product(basic_sales_tax_exempt: true))
      end

      def test_does_not_apply_to_a_product_in_an_exempt_category
        product = build_product(category: build_category(name: "book", basic_sales_tax_exempt: true))

        refute Basic.applies_to?(product)
      end

      def test_product_exemption_overrides_its_category
        product = build_product(category: build_category(name: "medical"), basic_sales_tax_exempt: true)

        refute Basic.applies_to?(product)
      end

      def test_applies_regardless_of_import_status
        assert Basic.applies_to?(build_product(imported: true))
      end
    end
  end
end
