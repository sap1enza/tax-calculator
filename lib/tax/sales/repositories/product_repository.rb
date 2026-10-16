# frozen_string_literal: true

module Tax
  module Sales
    module Repositories
      class ProductRepository
        NotFoundError = Class.new(Error)
        InvalidDataError = Class.new(Error)

        DATA_DIR = File.join(Tax::ROOT, "data")

        def self.load
          categories = read("product_categories.csv").to_h do |row|
            category = Objects::ProductCategory.new(**Parsers::ProductCategoryParser.call(row))
            [category.id, category]
          end

          products = read("products.csv").map do |row|
            attributes = Parsers::ProductParser.call(row)
            category_id = attributes.delete(:category_id)
            category = categories.fetch(category_id) { raise NotFoundError, "Unknown category: #{category_id}" }
            Objects::Product.new(**attributes, category:)
          end

          new(products)
        rescue ArgumentError, TypeError, KeyError, CSV::MalformedCSVError, Errno::ENOENT, NotFoundError => e
          raise InvalidDataError, "Invalid catalog data: #{e.message}"
        end

        def self.read(filename)
          CSV.foreach(File.join(DATA_DIR, filename), headers: true)
        end

        private_class_method :read

        def initialize(products)
          @products = products.to_h { |product| [product.id, product] }
        end

        def find(id)
          @products.fetch(id) { raise NotFoundError, "Unknown product: #{id}" }
        end
      end
    end
  end
end
