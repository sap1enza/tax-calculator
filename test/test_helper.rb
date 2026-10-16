# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "faker"
require_relative "../lib/tax"

module Factories
  def build_category(**overrides)
    defaults = {
      id: Faker::Number.unique.between(from: 1, to: 1_000),
      name: Faker::Commerce.department(max: 1),
      basic_sales_tax_exempt: false
    }

    Tax::Sales::Objects::ProductCategory.new(**defaults, **overrides)
  end

  def build_product(**overrides)
    defaults = {
      id: Faker::Number.unique.between(from: 1, to: 1_000),
      name: Faker::Commerce.product_name,
      category: build_category,
      basic_sales_tax_exempt: nil,
      imported: false,
      price: BigDecimal(Faker::Commerce.price(range: 0.01..100.0).to_s)
    }

    Tax::Sales::Objects::Product.new(**defaults, **overrides)
  end
end

Minitest::Test.include Factories
