# frozen_string_literal: true

module Tax
  module Sales
    module Parsers
      module Types
        BOOLEANS = { "true" => true, "false" => false }.freeze

        module_function

        def optional_boolean(value)
          return if value.nil? || value.strip.empty?

          BOOLEANS.fetch(value.strip) { raise ArgumentError, "invalid boolean: #{value.inspect}" }
        end

        def boolean(value)
          optional_boolean(value) || false
        end

        def decimal(value)
          BigDecimal(value)
        end

        def positive_integer(value)
          Integer(value).tap { |number| raise ArgumentError, "must be positive: #{value}" unless number.positive? }
        end
      end
    end
  end
end
