# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    module Parsers
      class TypesTest < Minitest::Test
        def test_boolean_parses_true_and_false
          assert Types.boolean("true")
          refute Types.boolean("false")
        end

        def test_boolean_ignores_surrounding_whitespace
          assert Types.boolean(" true ")
        end

        def test_boolean_defaults_to_false_when_blank
          refute Types.boolean(nil)
          refute Types.boolean("")
        end

        def test_boolean_rejects_other_values
          assert_raises(ArgumentError) { Types.boolean("yes") }
        end

        def test_optional_boolean_returns_nil_when_blank
          assert_nil Types.optional_boolean(nil)
          assert_nil Types.optional_boolean("  ")
        end

        def test_optional_boolean_parses_true_and_false
          assert Types.optional_boolean("true")
          refute Types.optional_boolean("false")
        end

        def test_positive_decimal_returns_a_big_decimal
          assert_equal BigDecimal("12.49"), Types.positive_decimal("12.49")
          assert_kind_of BigDecimal, Types.positive_decimal("12.49")
        end

        def test_positive_decimal_rejects_non_numbers
          assert_raises(ArgumentError) { Types.positive_decimal("abc") }
        end

        def test_positive_decimal_rejects_zero_and_negatives
          assert_raises(ArgumentError) { Types.positive_decimal("0") }
          assert_raises(ArgumentError) { Types.positive_decimal("-1.00") }
        end

        def test_positive_integer_parses_whole_numbers
          assert_equal 3, Types.positive_integer("3")
        end

        def test_positive_integer_rejects_zero_negative_and_fractions
          assert_raises(ArgumentError) { Types.positive_integer("0") }
          assert_raises(ArgumentError) { Types.positive_integer("-1") }
          assert_raises(ArgumentError) { Types.positive_integer("1.5") }
        end
      end
    end
  end
end
