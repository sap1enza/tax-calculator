# Sales Tax Receipt

A small Ruby application that reads a shopping order and prints a receipt with sales taxes applied.

- Basic sales tax: 10% on all goods, except books and food, and medical products marked as exempt.
- Import duty: 5% on all imported goods, no exemptions.
- Each tax amount is rounded up to the nearest 0.05 per unit.

## Requirements

- Ruby 4.0.7 (see `.ruby-version`)
- Bundler

## How to run

```sh
bundle install
bin/receipt inputs/order_1.csv
```

Output:

```
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

The three sample baskets from the challenge are `inputs/order_1.csv`, `order_2.csv` and `order_3.csv`. Each one produces the expected output exactly.

Invalid input ends with a one-line message and a non-zero exit code:

```
$ bin/receipt inputs/missing.csv
Error: No such file or directory @ rb_sysopen - inputs/missing.csv

$ bin/receipt bad_order.csv
Error: Line 2: Unknown product: 99
```

## Running the tests

```sh
bundle exec rake
```

Tests live in `test/` and mirror the `lib/` structure (`lib/tax/sales/objects/product.rb` → `test/lib/tax/sales/objects/product_test.rb`). Minitest is used with plain `Minitest::Test` classes. Faker provides random values for attributes that don't affect the behaviour under test.

## Input format

The application mimics a small relational setup. Catalog data lives in `data/` and an order references it by id, like an `order_items` table.

`data/product_categories.csv`

```
id,name,basic_sales_tax_exempt
1,book,true
2,medical,false
3,food,true
```

`data/products.csv`

```
id,category_id,name,basic_sales_tax_exempt,imported,price
1,1,book,,false,12.49
8,2,packet of headache pills,true,false,9.75
```

`inputs/order_1.csv`

```
product_id,quantity
1,2
2,1
```

## Assumptions

- **Exemption is resolved per product, falling back to its category.** Books and food are exempt at category level. Medical is taxed by default; a medical product is exempt only when its own `basic_sales_tax_exempt` column says so (e.g. headache pills). A blank product value means "use the category".
- **Imported is a product flag**, not inferred from the name. The receipt prints the product name as stored, so "imported bottle of perfume" keeps the word in its name.
- **Rounding happens per unit, then multiplied by quantity.** Three imported boxes of chocolates at 11.25 give 3 × 1.70 = 5.10 of tax (total 35.55), as in the expected output. Rounding the whole line would give 35.45.
- **Rates are combined before rounding.** A taxable imported product is taxed at 15% and rounded once. With the given data this matches rounding each tax separately.
- **Money is `BigDecimal`**, never `Float`, to avoid representation errors.
- **One order per run.** `bin/receipt` takes exactly one CSV path.

## Project structure

```
bin/receipt                       # entry point
data/                             # catalog: product_categories.csv, products.csv
inputs/                           # sample orders
lib/tax.rb                        # namespace, Tax::Error, Tax::ROOT, requires
lib/tax/sales/
  basic.rb                        # Basic sales tax rule: rate and applies_to?
  import_duty.rb                  # Import duty rule: rate and applies_to?
  objects/                        # immutable value objects (Data.define)
    product_category.rb
    product.rb
    order_item.rb                 # product + quantity, computes its own tax and total
    order.rb                      # list of order items
    receipt.rb                    # wraps an order, sums taxes and totals
  parsers/                        # raw CSV row -> typed attributes hash
    types.rb                      # shared conversions: boolean, decimal, positive_integer
    product_category_parser.rb
    product_parser.rb
    order_item_parser.rb
    order_parser.rb
  repositories/
    product_repository.rb         # loads the catalog, find(id)
  services/                       # single .call entry point each
    calculator_service.rb         # tax for one unit of a product
    order_import_service.rb       # order CSV -> Order
    receipt_formatter_service.rb  # Receipt -> printable text
test/                             # mirrors lib/
```

### Flow

```
order CSV
  → Parsers::OrderParser          typed rows, line numbers on errors
  → OrderImportService            swaps product_id for a Product via the repository
  → Objects::Order                immutable
  → Objects::Receipt              sums item taxes and totals
  → ReceiptFormatterService       text
```

Tax for one unit: `CalculatorService` asks each rule (`Basic`, `ImportDuty`) whether it applies to the product, sums the applicable rates, and rounds up to 0.05. The two rules share the same shape (`rate`, `applies_to?`), so adding a new tax means adding one module to `CalculatorService::TAXES`.

## Design notes

- **Immutable objects.** Every object is a `Data.define`, frozen at creation. Totals are computed on demand, never stored.
- **Stateless services.** Each service takes its input in `initialize`, exposes `.call`, and keeps no state between calls. Given the same input it returns the same output, so concurrent runs cannot interfere with each other.
- **One error hierarchy.** All errors inherit from `Tax::Error`, so `bin/receipt` rescues a single class.
- **Namespaced by use case.** Everything lives under `Tax::Sales`, leaving room for `Tax::Purchase` or similar without clashes.

### Possible extensions

- Replace `data/` with a database: `ProductRepository` is the only class that reads CSV, so it is the only one to change.
- Replace the objects with ORM models: the objects folder holds plain value objects with the same attribute names a table would have.
- Drop the parsers if input no longer arrives as CSV: they only translate raw strings into typed attributes.
