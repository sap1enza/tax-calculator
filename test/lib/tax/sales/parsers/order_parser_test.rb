# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Parsers
      class OrderParserTest < Minitest::Test
        def test_returns_one_item_per_row
          rows = [{ "product_id" => "1", "quantity" => "2" }, { "product_id" => "3", "quantity" => "1" }]

          assert_equal({ items: [{ product_id: "1", quantity: 2 }, { product_id: "3", quantity: 1 }] }, OrderParser.call(rows))
        end

        def test_returns_no_items_for_no_rows
          assert_equal({ items: [] }, OrderParser.call([]))
        end

        def test_prefixes_errors_with_the_csv_line_number
          rows = [{ "product_id" => "1", "quantity" => "2" }, { "product_id" => "1", "quantity" => "0" }]
          error = assert_raises(ArgumentError) { OrderParser.call(rows) }

          assert_equal "Line 3: must be positive: 0", error.message
        end

        def test_reports_a_missing_column_on_its_line
          error = assert_raises(ArgumentError) { OrderParser.call([{ "product_id" => "1" }]) }

          assert_match(/\ALine 2: /, error.message)
        end
      end
    end
  end
end
