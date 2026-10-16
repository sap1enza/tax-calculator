# frozen_string_literal: true

require "test_helper"
require "tmpdir"

module Tax
  module Sales
    module Repositories
      class ProductRepositoryTest < Minitest::Test
        CATEGORIES = "id,name,basic_sales_tax_exempt\n1,book,true\n2,medical,false\n"
        PRODUCTS = "id,category_id,name,basic_sales_tax_exempt,imported,price\n1,1,book,,false,12.49\n2,2,headache pills,true,true,9.75\n"

        def test_find_returns_the_product_by_id
          product = build_product(id: "1")

          assert_same product, ProductRepository.new([product]).find("1")
        end

        def test_find_raises_for_an_unknown_id
          error = assert_raises(ProductRepository::NotFoundError) { ProductRepository.new([]).find("99") }

          assert_equal "Unknown product: 99", error.message
        end

        def test_load_reads_products_and_links_their_categories
          with_data_dir do |dir|
            product = ProductRepository.load(dir).find("2")

            assert_equal "headache pills", product.name
            assert_equal "medical", product.category.name
            assert_equal BigDecimal("9.75"), product.price
            assert product.imported?
            assert product.basic_sales_tax_exempt?
          end
        end

        def test_load_reads_the_default_data_directory
          assert_equal "book", ProductRepository.load.find("1").name
        end

        def test_load_raises_for_an_unknown_category
          with_data_dir(products: "#{PRODUCTS}3,9,ghost,,false,1.00\n") do |dir|
            error = assert_raises(ProductRepository::InvalidDataError) { ProductRepository.load(dir) }

            assert_match(/Unknown category: 9/, error.message)
          end
        end

        def test_load_raises_for_invalid_values
          with_data_dir(products: "#{PRODUCTS}3,1,bad,maybe,false,1.00\n") do |dir|
            assert_raises(ProductRepository::InvalidDataError) { ProductRepository.load(dir) }
          end
        end

        def test_load_raises_for_a_missing_file
          Dir.mktmpdir do |dir|
            assert_raises(ProductRepository::InvalidDataError) { ProductRepository.load(dir) }
          end
        end

        def test_errors_inherit_from_tax_error
          assert_operator ProductRepository::NotFoundError, :<, Tax::Error
          assert_operator ProductRepository::InvalidDataError, :<, Tax::Error
        end

        private

        def with_data_dir(categories: CATEGORIES, products: PRODUCTS)
          Dir.mktmpdir do |dir|
            File.write(File.join(dir, "product_categories.csv"), categories)
            File.write(File.join(dir, "products.csv"), products)
            yield dir
          end
        end
      end
    end
  end
end
