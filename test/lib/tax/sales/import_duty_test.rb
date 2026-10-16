# frozen_string_literal: true

require "test_helper"

module Tax
  module Sales
    class ImportDutyTest < Minitest::Test
      def test_rate_is_five_percent
        assert_equal 5, ImportDuty.rate
      end

      def test_applies_to_an_imported_product
        assert ImportDuty.applies_to?(build_product(imported: true))
      end

      def test_does_not_apply_to_a_local_product
        refute ImportDuty.applies_to?(build_product(imported: false))
      end

      def test_applies_regardless_of_basic_sales_tax_exemption
        assert ImportDuty.applies_to?(build_product(imported: true, basic_sales_tax_exempt: true))
      end
    end
  end
end
