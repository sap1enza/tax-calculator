# frozen_string_literal: true

require "test_helper"

class TaxTest < Minitest::Test
  def test_error_inherits_from_standard_error
    assert_operator Tax::Error, :<, StandardError
  end

  def test_loads_stdlib_dependencies
    assert Object.const_defined?(:BigDecimal), "BigDecimal is not loaded"
    assert Object.const_defined?(:CSV), "CSV is not loaded"
  end
end
