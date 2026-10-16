# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Parsers
      class OrderItemParserTest < Minitest::Test
        def test_returns_typed_attributes
          assert_equal({ product_id: "1", quantity: 2 }, OrderItemParser.call({ "product_id" => "1", "quantity" => "2" }))
        end

        def test_raises_for_a_non_positive_quantity
          assert_raises(ArgumentError) { OrderItemParser.call({ "product_id" => "1", "quantity" => "0" }) }
        end

        def test_raises_for_a_missing_column
          assert_raises(KeyError) { OrderItemParser.call({ "product_id" => "1" }) }
        end
      end
    end
  end
end
