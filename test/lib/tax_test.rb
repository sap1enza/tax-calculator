# frozen_string_literal: true

require "test_helper"

class TaxTest < Minitest::Test
  CONSTANTS = %w[
    Tax::Sales::Objects::ProductCategory
    Tax::Sales::Objects::Product
    Tax::Sales::Objects::OrderItem
    Tax::Sales::Objects::Order
    Tax::Sales::Objects::Receipt
    Tax::Sales::Basic
    Tax::Sales::ImportDuty
  ].freeze

  def test_error_inherits_from_standard_error
    assert_operator Tax::Error, :<, StandardError
  end

  def test_loads_every_constant
    CONSTANTS.each do |name|
      assert Object.const_defined?(name), "#{name} is not loaded"
    end
  end

  def test_loads_stdlib_dependencies
    assert Object.const_defined?(:BigDecimal), "BigDecimal is not loaded"
    assert Object.const_defined?(:CSV), "CSV is not loaded"
  end
end
