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
require_relative "tax/sales/parsers/types"
require_relative "tax/sales/parsers/product_category_parser"
require_relative "tax/sales/parsers/product_parser"
require_relative "tax/sales/parsers/order_item_parser"
require_relative "tax/sales/parsers/order_parser"
require_relative "tax/sales/repositories/product_repository"
require_relative "tax/sales/basic"
require_relative "tax/sales/import_duty"

