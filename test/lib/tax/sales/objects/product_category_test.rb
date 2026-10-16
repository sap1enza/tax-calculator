# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Objects
      class ProductCategoryTest < Minitest::Test
        def test_exposes_its_attributes
          category = build_category(id: 3, name: "food", basic_sales_tax_exempt: true)

          assert_equal 3, category.id
          assert_equal "food", category.name
          assert category.basic_sales_tax_exempt?
        end

        def test_requires_every_attribute
          assert_raises(ArgumentError) { ProductCategory.new(id: 1, name: "book") }
        end

        def test_is_immutable
          assert_predicate build_category, :frozen?
          refute_respond_to build_category, :name=
        end

        def test_equality_is_by_value
          category = build_category

          assert_equal category, ProductCategory.new(**category.to_h)
        end
      end
    end
  end
end
