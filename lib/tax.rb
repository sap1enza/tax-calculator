# frozen_string_literal: true

require "bigdecimal"
require "csv"

module Tax
  Error = Class.new(StandardError)
end

require_relative "tax/sales/objects/product_category"
require_relative "tax/sales/objects/product"
require_relative "tax/sales/basic"
require_relative "tax/sales/import_duty"
