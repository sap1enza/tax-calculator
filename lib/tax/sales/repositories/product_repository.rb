# frozen_string_literal: true

module Tax
  module Sales
    module Repositories
      class ProductRepository
        NotFoundError = Class.new(Error)
        InvalidDataError = Class.new(Error)

        DATA_DIR = File.join(Tax::ROOT, "data")

        def self.load(data_dir = DATA_DIR)
          categories = index(read(data_dir, "product_categories.csv").map do |row|
            Objects::ProductCategory.new(**Parsers::ProductCategoryParser.call(row))
          end)

          products = read(data_dir, "products.csv").map do |row|
            attributes = Parsers::ProductParser.call(row)
            category_id = attributes.delete(:category_id)
            category = categories.fetch(category_id) { raise NotFoundError, "Unknown category: #{category_id}" }
            Objects::Product.new(**attributes, category:)
          end

          new(index(products).values)
        rescue ArgumentError, TypeError, KeyError, CSV::MalformedCSVError, Errno::ENOENT, NotFoundError => e
          raise InvalidDataError, "Invalid catalog data: #{e.message}"
        end

        def self.read(data_dir, filename)
          CSV.foreach(File.join(data_dir, filename), headers: true, encoding: "bom|utf-8")
        end

        def self.index(records)
          records.each_with_object({}) do |record, by_id|
            raise InvalidDataError, "Duplicate id: #{record.id}" if by_id.key?(record.id)

            by_id[record.id] = record
          end
        end
        private_class_method :read, :index

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
