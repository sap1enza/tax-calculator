# frozen_string_literal: true

require "bigdecimal"
require "csv"

module Tax
  ROOT = File.expand_path("..", __dir__)
  Error = Class.new(StandardError)
end

require_relative "tax/sales/objects/product_category"
require_relative "tax/sales/objects/product"
require_relative "tax/sales/objects/order_item"
require_relative "tax/sales/objects/order"
require_relative "tax/sales/objects/receipt"
require_relative "tax/sales/repositories/product_repository"
require_relative "tax/sales/basic"
require_relative "tax/sales/import_duty"
