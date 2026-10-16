# frozen_string_literal: true

require "test_helper"
require "tempfile"

module Tax
  module Sales
    module Services
      class OrderImportServiceTest < Minitest::Test
        def setup
          @book = build_product(id: "1", name: "book")
          @cd = build_product(id: "2", name: "music CD")
          @repository = Repositories::ProductRepository.new([@book, @cd])
        end

        def test_returns_an_order_with_one_item_per_row
          order = import("product_id,quantity\n1,2\n2,1\n")

          assert_kind_of Objects::Order, order
          assert_equal [[@book, 2], [@cd, 1]], order.items.map { |item| [item.product, item.quantity] }
        end

        def test_returns_an_empty_order_for_a_header_only_file
          assert_empty import("product_id,quantity\n").items
        end

        def test_raises_for_an_unknown_product_with_its_line_number
          error = assert_raises(OrderImportService::InvalidOrderError) { import("product_id,quantity\n1,1\n99,1\n") }

          assert_equal "Line 3: Unknown product: 99", error.message
        end

        def test_raises_for_an_invalid_quantity_with_its_line_number
          error = assert_raises(OrderImportService::InvalidOrderError) { import("product_id,quantity\n1,0\n") }

          assert_equal "Line 2: must be positive: 0", error.message
        end

        def test_ignores_a_utf8_bom
          order = import("\uFEFFproduct_id,quantity\n1,1\n")

          assert_equal [@book], order.items.map(&:product)
        end

        def test_raises_for_a_missing_column
          assert_raises(OrderImportService::InvalidOrderError) { import("product_id\n1\n") }
        end

        def test_raises_for_a_missing_file
          assert_raises(OrderImportService::InvalidOrderError) { OrderImportService.call("missing.csv", repository: @repository) }
        end

        def test_raises_for_malformed_csv
          assert_raises(OrderImportService::InvalidOrderError) { import("product_id,quantity\n\"1,1\n") }
        end

        def test_error_inherits_from_tax_error
          assert_operator OrderImportService::InvalidOrderError, :<, Tax::Error
        end

        private

        def import(csv)
          Tempfile.create(["order", ".csv"]) do |file|
            file.write(csv)
            file.flush
            OrderImportService.call(file.path, repository: @repository)
          end
        end
      end
    end
  end
end
