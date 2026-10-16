# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Parsers
      class ProductCategoryParserTest < Minitest::Test
        def test_returns_typed_attributes
          row = { "id" => "1", "name" => "book", "basic_sales_tax_exempt" => "true" }

          assert_equal({ id: "1", name: "book", basic_sales_tax_exempt: true }, ProductCategoryParser.call(row))
        end

        def test_blank_exemption_defaults_to_false
          row = { "id" => "4", "name" => "music", "basic_sales_tax_exempt" => "" }

          refute ProductCategoryParser.call(row).fetch(:basic_sales_tax_exempt)
        end

        def test_raises_for_a_missing_column
          assert_raises(KeyError) { ProductCategoryParser.call({ "id" => "1", "name" => "book" }) }
        end

        def test_builds_a_product_category
          row = { "id" => "1", "name" => "book", "basic_sales_tax_exempt" => "true" }

          assert_kind_of Objects::ProductCategory, Objects::ProductCategory.new(**ProductCategoryParser.call(row))
        end
      end
    end
  end
end
