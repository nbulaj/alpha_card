# Ruby lib for creating payments with Alpha Card Services
[![Gem Version](https://badge.fury.io/rb/alpha_card.svg)](http://badge.fury.io/rb/alpha_card)
[![Build Status](https://travis-ci.org/nbulaj/alpha_card.svg?branch=master)](https://travis-ci.org/nbulaj/alpha_card)
[![Dependency Status](https://gemnasium.com/nbulaj/alpha_card.svg)](https://gemnasium.com/nbulaj/alpha_card)
[![Code Climate](https://codeclimate.com/github/nbulaj/alpha_card/badges/gpa.svg)](https://codeclimate.com/github/nbulaj/alpha_card)
[![Coverage Status](https://coveralls.io/repos/github/nbulaj/alpha_card/badge.svg)](https://coveralls.io/github/nbulaj/alpha_card)
[![Inline docs](http://inch-ci.org/github/nbulaj/alpha_card.png?branch=master)](http://inch-ci.org/github/nbulaj/alpha_card)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](#license)

This gem can help your Ruby, JRuby or Ruby on Rails application to integrate with Alpha Card Service, Inc.

Alpha Card Services: 
http://www.alphacardservices.com/

Payment Gateway Integration Portal:
https://secure.alphacardgateway.com/merchants/resources/integration/integration_portal.php

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Alpha Card Objects & Transactions](#alpha-card-objects--transactions)
  - [Order](#order)
    - [Billing](#billing)
    - [Shipping](#shipping)
  - [Sale](#sale)
  - [Refund](#refund)
  - [Void](#void)
  - [Capture](#capture)
  - [Update](#update)
  - [Authorization](#authorization)
  - [Credit](#credit)
  - [Validate](#validate)
- [Example of usage](#example-of-usage)
- [AlphaCard Response](#alphacard-response)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Installation

If using bundler, first add 'alpha_card' to your Gemfile:

```ruby
gem 'alpha_card', '~> 0.4'
```

And run:

```sh
bundle install
```

Otherwise simply install the gem:

```sh
gem install alpha_card -v '0.4'
```

Dependencies required:

*  ruby >= 2.2.2 or [jruby](https://github.com/jruby/jruby) >= 9.0.5.0;

## Configuration

In order to use Alpha Card Gateway API you need to have a Merchant account credentials such as `username` and `password`.

If your project will always use only one account for processing payments, then you can configure gem as follows:

```ruby
AlphaCard::Account.username = 'username'
AlphaCard::Account.password = 'password'
```

In Rails applications you can create an initializer:

```ruby
# config/initializers/alpha_card.rb
if Rails.env.test? || Rails.env.ci?
  AlphaCard::Account.use_demo_credentials!
else
  AlphaCard::Account.username = 'username'
  AlphaCard::Account.password = 'password'
end
```

Another way is to pass the credentials as a last argument when creating some transactions or perform operations (it can be useful when you need to operate with multiple Alpha Card accounts):

```ruby
void = AlphaCard::Void.new(transaction_id: '312110')
void.process(username: 'demo', password: 'demo')
```

## Alpha Card Objects & Transactions

Alpha Card operates with next objects:

*  [Order](#order)
    - [Billing](#billing)
    - [Shipping](#shipping)
*  [Sale](#sale)/[Authorization](#authorization)/[Credit](#credit)/[Validate](#validate)
*  [Refund](#refund)
*  [Void](#void)
*  [Capture](#capture)
*  [Update](#update)

Let us consider each of them.

### Order

Order represents itself.

_Optional attributes_:

*  id : `String`
*  description : `String`
*  po_number : `String`
*  tax : `String`
*  ip_address : `String` (format: `xxx.xxx.xxx.xxx`)
*  billing : `AlphaCard::Billing`
*  shipping : `AlphaCard::Shipping`

_Constructor_:

```ruby
AlphaCard::Order.new(property: value, ...)
```

### Billing

Specify Billing information for Order.

_Optional attributes_:

*  first_name : `String`
*  last_name : `String`
*  email : `String`
*  fax : `String`
*  phone : `String`
*  company : `String`
*  address_1 : `String`
*  address_2 : `String`
*  city : `String`
*  state : `String` (format: `CC`)
*  zip : `String`
*  country : `String` (format: `CC`. Country codes are as shown in [ISO 3166](https://en.wikipedia.org/wiki/ISO_3166))
*  website : `String`

_Constructor_:

```ruby
AlphaCard::Billing.new(property: value, ...)
```

### Shipping

Contains Shipping information for the Order.

_Optional attributes_:

*  first_name : `String`
*  last_name : `String`
*  company : `String`
*  address_1 : `String`
*  address_2 : `String`
*  city : `String`
*  state : `String` (format: `CC`)
*  zip_code : `String`
*  country : `String` (format: `CC`. Country codes are as shown in [ISO 3166](https://en.wikipedia.org/wiki/ISO_3166))
*  email : `String`

_Constructor_:

```ruby
AlphaCard::Shipping.new(property: value, ...)
```

### Sale

Sale transaction is the main object of the Alpha Card Services. It is used to processed common payments for orders.

_Required attributes_:

*  card_expiration_date : `String` (format: `MMYY`)
*  card_number : `String`
*  amount : `String` (format: `x.xx`)

_Optional attributes_:

*  cvv : `String`
*  payment : `String` (default: `'creditcard'`, values: `'creditcard'` or `'check'`)
*  customer_receipt : `String` (values `'true'` or `'false'`)
*  check_name : `String`
*  check_aba : `String`
*  check_account : `String`
*  account_holder_type : `String` (values: `'business'` or `'personal'`)
*  account_type : `String` (values: `'checking'` or `'savings'`)
*  sec_code : `String` (values: `'PPD'`, `'WEB'`, `'TEL'`, or `'CCD'`)

_Constructor_:

```ruby
AlphaCard::Sale.new(property: value, ...)
```

To create the payment you must call *create(_alpha_card_order_)* method:

```ruby
# ...
sale = AlphaCard::Sale.new(amount: 10)
response = sale.process(order)

# => #<AlphaCard::Response:0x1a0fda ...>
```

### Refund

Represents refund transaction.

_Required attributes_:

*  transaction_id : `String` or `Integer`

_Optional attributes_:

*  amount : `String` (format: `x.xx`)

_Constructor_:

```ruby
AlphaCard::Refund.new(property: value, ...)
```

To create the refund transaction you must call *create* or *process* method:

```ruby
# ...
refund = AlphaCard::Refund.new(transaction_id: '12312312', amount: 10)
refund.process
```

### Void

Represents void transaction.

_Required attributes_:

*  transaction_id : `String` or `Integer`

_Constructor_:

```ruby
AlphaCard::Void.new(property: value, ...)
```

To create the void transaction you must call *create* or *process* method:

```ruby
# ...
void = AlphaCard::Void.new(transaction_id: '12312312')
void.create
```

### Capture

Represents capture transaction.

_Required attributes_:

*  transaction_id : `String` or `Integer`
*  amount : `String` (format: `xx.xx`)

_Optional attributes_:

*  tracking_number : `String`
*  shipping_carrier : `String`
*  order_id : `String`

_Constructor_:

```ruby
AlphaCard::Capture.new(property: value, ...)
```

To create the capture transaction you must call *create* or *process* method:

```ruby
# ...
capture = AlphaCard::Capture.new(transaction_id: '12312312', amount: '5.05')
capture.create
```

### Update

Represents update transaction.

_Required attributes_:

*  transaction_id : `String` or `Integer`

_Optional attributes_:
*  shipping: `String`
*  shipping_postal: `String`
*  ship_from_postal: `String`
*  shipping_country: `String` 
*  shipping_carrier: `String` (values: `'ups'`, `'fedex'`, `'dhl'` or `'usps'`)
*  shipping_date: `String` (format: `YYYYMMDD`)
*  order_description: `String`
*  order_date: `String`
*  customer_receipt: `String` (values: `'true'` or `'false'`)
*  po_number: `String`
*  summary_commodity_code: `String`
*  duty_amount: `String` (format: `x.xx`)
*  discount_amount: `String` (format: `x.xx`)
*  tax: `String` (format: `x.xx`)
*  national_tax_amount: `String` (format: `x.xx`)
*  alternate_tax_amount: `String` (format: `x.xx`)
*  alternate_tax_id: `String`
*  vat_tax_amount: `String`
*  vat_tax_rate: `String`
*  vat_invoice_reference_number: `String`
*  customer_vat_registration: `String`
*  merchant_vat_registration: `String`

_Constructor_:

```ruby
AlphaCard::Update.new(property: value, ...)
```

To create update transaction you must call *create* or *process* method:

```ruby
# ...
update = AlphaCard::Update.new(tax: '10.02', shipping_carrier: 'ups', transaction_id: '66928')
update.process
```

### Authorization

Has the same attributes and methods as `Sale` transaction.

### Credit

Has the same attributes and methods as `Sale` transaction.

### Validate

Has the same attributes and methods as `Sale` transaction, except `amount` — there is no need in it.

## Example of usage

Create AlphaCard sale (pay for the order):

```ruby
require 'alpha_card'

def create_payment
  # Setup merchant account credentials
  AlphaCard::Account.username = 'demo'
  AlphaCard::Account.password = 'password'

  billing = AlphaCard::Billing.new(email: 'test@example.com', phone: '+801311313111')
  shipping = AlphaCard::Shipping.new(address_1: '33 N str', city: 'New York', state: 'NY', zip_code: '132')

  order = AlphaCard::Order.new(id: 1, description: 'Test order', billing: billing, shipping: shipping)

  # Format of the amount: "XX.XX"
  sale = AlphaCard::Sale.new(card_expiration_date: '0117', card_number: '4111111111111111', amount: '1.50', cvv: '123')
  response = sale.create(order)
  #=> #<AlphaCard::Response:0x1a0fda ...>

  if response.success?
    puts "Order payed successfully: transaction ID = #{response.transaction_id}"
    true
  else
    puts "Error message: #{e.response.message}"
    puts "CVV response: #{e.response.cvv_response}"
    puts "AVS response: #{e.response.avs_response}"
    false
  end

  rescue AlphaCard::APIConnectionError => e
    puts "Connection problems: #{e.message}"
    false
end
```

`Billing` and `Shipping` is an _optional_ parameters and can be not specified.

_Note_: take a look at the `amount` of the Order. It's format must be 'xx.xx'. All the information about variables formats 
can be found on _Alpha Card Payment Gateway Integration Portal_ -> _Direct Post API_ -> _Documentation_ -> _Transaction Variables_

To simulate request that returns an error do the next:

*  to cause a declined message, pass an amount less than 1.00;
*  to trigger a fatal error message, pass an invalid card number;
*  to simulate an AVS match, pass 888 in the address1 field, 77777 for zip;
*  to simulate a CVV match, pass 999 in the cvv field.

## AlphaCard Response

`AlphaCard::Response` contains all the necessary information about Alpha Card Gateway response. You can use the following API:

*  `.text` — textual response of the Alpha Card Gateway;
*  `.message` — response message be response code;
*  `.transaction_id` — payment gateway transaction ID;
*  `.order_id` — original order ID passed in the transaction request;
*  `.code` — numeric mapping of processor responses;
*  `.auth_code` — transaction authorization code;
*  `.success?`, `.error?`, `.declined?` — state of the request;
*  `.cvv_response` — CVV response message;
*  `.avs_response` — AVS response message.

## Testing

It is recommended to mock Alpha Card gem functionality, but if you want to create a "real" specs, then you can use Alpha Card Services testing account:

```ruby
AlphaCard::Account.use_demo_credentials!
```

Or you can pass the next credentials with any request: `{ username: 'demo', password: 'password' }`

## Contributing

You are very welcome to help improve alpha_card if you have suggestions for features that other people can use.

To contribute:

1. Fork the project.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run <tt>rake doc:yard</tt>. If your changes are not 100% documented, go back to step 4.
6. Add tests for your feature or bug fix.
7. Run `rake` to make sure all tests pass.
8. Commit your changes (`git commit -am 'Add new feature'`).
9. Push to the branch (`git push origin my-new-feature`).
10. Create new pull request.

Thanks.

## License

Alpha Card gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) 2014-2017 Nikita Bulai (bulajnikita@gmail.com).
