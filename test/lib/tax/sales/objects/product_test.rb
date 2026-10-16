# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Objects
      class ProductTest < Minitest::Test
        def test_exposes_its_attributes
          category = build_category
          product = build_product(id: 7, name: "bottle of perfume", category:, imported: true, price: BigDecimal("18.99"))

          assert_equal 7, product.id
          assert_equal "bottle of perfume", product.name
          assert_same category, product.category
          assert product.imported?
          assert_equal BigDecimal("18.99"), product.price
        end

        def test_requires_every_attribute
          assert_raises(ArgumentError) { Product.new(id: 1, name: "book") }
        end

        def test_is_immutable
          assert_predicate build_product, :frozen?
          refute_respond_to build_product, :price=
        end

        def test_exemption_falls_back_to_category_when_unset
          exempt = build_category(basic_sales_tax_exempt: true)

          assert build_product(category: exempt, basic_sales_tax_exempt: nil).basic_sales_tax_exempt?
          refute build_product(category: build_category, basic_sales_tax_exempt: nil).basic_sales_tax_exempt?
        end

        def test_exemption_overrides_category_when_set
          exempt = build_category(basic_sales_tax_exempt: true)

          assert build_product(category: build_category, basic_sales_tax_exempt: true).basic_sales_tax_exempt?
          refute build_product(category: exempt, basic_sales_tax_exempt: false).basic_sales_tax_exempt?
        end
      end
    end
  end
end
