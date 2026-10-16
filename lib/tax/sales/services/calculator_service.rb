# frozen_string_literal: true

module Tax
  module Sales
    module Services
      class CalculatorService
        TAXES = [Basic, ImportDuty].freeze
        ROUNDING_STEP = BigDecimal("0.05")

        def self.call(...) = new(...).call

        def initialize(product)
          @product = product
        end

        def call
          round_up(@product.price * rate / 100)
        end

        private

        def rate
          TAXES.select { |tax| tax.applies_to?(@product) }.sum(&:rate)
        end

        def round_up(amount)
          (amount / ROUNDING_STEP).ceil * ROUNDING_STEP
        end
      end
    end
  end
end
