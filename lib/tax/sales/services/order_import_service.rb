# frozen_string_literal: true

module Tax
  module Sales
    module Services
      class OrderImportService
        InvalidOrderError = Class.new(Error)

        def self.call(...) = new(...).call

        def initialize(path, repository:)
          @path = path
          @repository = repository
        end

        def call
          attributes = Parsers::OrderParser.call(CSV.foreach(@path, headers: true, encoding: "bom|utf-8"))
          items = attributes.fetch(:items).each.with_index(2).map { |item, line| build_item(item, line) }
          Objects::Order.new(items:)
        rescue ArgumentError, CSV::MalformedCSVError, Errno::ENOENT => e
          raise InvalidOrderError, e.message
        end

        private

        def build_item(attributes, line)
          product = @repository.find(attributes.fetch(:product_id))
          Objects::OrderItem.new(product:, quantity: attributes.fetch(:quantity))
        rescue Repositories::ProductRepository::NotFoundError => e
          raise InvalidOrderError, "Line #{line}: #{e.message}"
        end
      end
    end
  end
end
