# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Objects
      class OrderTest < Minitest::Test
        def test_exposes_its_items
          items = [build_order_item, build_order_item]

          assert_equal items, Order.new(items:).items
        end

        def test_requires_items
          assert_raises(ArgumentError) { Order.new }
        end

        def test_is_immutable
          assert_predicate Order.new(items: []), :frozen?
          refute_respond_to Order.new(items: []), :items=
        end
      end
    end
  end
end
