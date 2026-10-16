# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Parsers
      class ProductParserTest < Minitest::Test
        ROW = {
          "id" => "8", "category_id" => "2", "name" => "packet of headache pills",
          "basic_sales_tax_exempt" => "true", "imported" => "false", "price" => "9.75"
        }.freeze

        def test_returns_typed_attributes
          expected = {
            id: "8", category_id: "2", name: "packet of headache pills",
            basic_sales_tax_exempt: true, imported: false, price: BigDecimal("9.75")
          }

          assert_equal expected, ProductParser.call(ROW)
        end

        def test_blank_exemption_is_nil_so_the_category_decides
          assert_nil ProductParser.call(ROW.merge("basic_sales_tax_exempt" => "")).fetch(:basic_sales_tax_exempt)
        end

        def test_blank_imported_defaults_to_false
          refute ProductParser.call(ROW.merge("imported" => "")).fetch(:imported)
        end

        def test_raises_for_an_invalid_price
          assert_raises(ArgumentError) { ProductParser.call(ROW.merge("price" => "free")) }
        end

        def test_raises_for_a_missing_column
          assert_raises(KeyError) { ProductParser.call(ROW.except("price")) }
        end
      end
    end
  end
end
