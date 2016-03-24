# Ruby lib for creating payments with Alpha Card Services
[![Gem Version](https://badge.fury.io/rb/alpha_card.svg)](http://badge.fury.io/rb/alpha_card)
[![Dependency Status](https://gemnasium.com/nbulaj/alpha_card.svg)](https://gemnasium.com/nbulaj/alpha_card)
[![Code Climate](https://codeclimate.com/github/nbulaj/alpha_card/badges/gpa.svg)](https://codeclimate.com/github/nbulaj/alpha_card)
[![Coverage Status](https://coveralls.io/repos/nbulaj/alpha_card/badge.svg)](https://coveralls.io/r/nbulaj/alpha_card)
[![Build Status](https://travis-ci.org/nbulaj/alpha_card.svg?branch=master)](https://travis-ci.org/nbulaj/alpha_card)
[![Inline docs](http://inch-ci.org/github/nbulaj/alpha_card.png?branch=master)](http://inch-ci.org/github/nbulaj/alpha_card)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](#license)
[![Gem](https://img.shields.io/gem/dt/alpha_card.svg)]()

This gem can help your Ruby or Ruby on Rails application to integrate with Alpha Card Service, Inc.

Alpha Card Services: 
http://www.alphacardservices.com/
     
Payment Gateway Integration Portal:
https://secure.alphacardgateway.com/merchants/resources/integration/integration_portal.php


## Installation

If using bundler, first add 'alpha_card' to your Gemfile:

```ruby
gem "alpha_card"
```

And run:

```sh
bundle install
```

Otherwise simply install the gem:

```sh
gem install alpha_card
```

Dependencies required:

*   ruby >= 1.9.3;


## Alpha Card Objects

Alpha Card operates with next 5 objects:

*   Account (represent your Alpha Card credentials)
*   Order
    - Billing
    - Shipping
*   Sale

Let us consider each of them.

### Account

Account represents credentials data to access Alpha Card Gateway.
All sales will be created for the specified account.

_Required fields_:

*   username : String
*   password : String

_Constructor_:

```ruby
AlphaCard::Account.new(username, password)
```

### Order

Order represents itself.

_Unnecessary fields_:

*   orderid : String
*   orderdescription : String
*   ponumber : String
*   tax : String
*   ipaddress : String
*   billing : AlphaCard::Billing
*   shipping : AlphaCard::Shipping

_Constructor_:

```ruby
AlphaCard::Order.new(field_name: value, ...)
```

### Billing

Specify Billing information for Order.

_Unnecessary fields_:

*   firstname : String
*   lastname : String
*   email : String
*   fax : String
*   phone : String
*   company : String
*   address1 : String
*   address2 : String
*   city : String
*   state : String
*   zip : String
*   country : String
*   website : String

_Constructor_:

```ruby
AlphaCard::Billing.new(field_name: value, ...)
```

### Shipping

Specify Shipping information for Order.

_Unnecessary fields_:

*   firstname : String
*   lastname : String
*   company : String
*   address_1 : String
*   address_2 : String
*   city : String
*   state : String
*   zip_code : String
*   country : String
*   email : String

_Constructor_:

```ruby
AlphaCard::Shipping.new(field_name: value, ...)
```

### Sale

Sale is the main object of the Alpha Card Services. It processes fees associated with credit cards.

_Required fields_:

*   ccexp : String
*   ccnumber : String
*   amount : String

_Unnecessary fields_:
*   cvv : String

_Constructor_:

```ruby
AlphaCard::Sale.new(field_name: value, ...)
```

To create the payment you must call *create(_alpha_card_order_, _alpha_card_account_)* method:

```ruby
...
sale = AlphaCard::Sale.new(amount: 10)
sale.create(order, account)
```

This method returns _true_ if sale was created successfully and raise an `AlphaCardError` exception if some of the fields is invalid.

## Example of usage

Create AlphaCard sale:

```ruby
require 'alpha_card'

def create_payment
  account = AlphaCard::Account.new('demo', 'password')

  billing = AlphaCard::Billing.new({ email: 'test@example.com', phone: '+801311313111' })
  shipping = AlphaCard::Shipping.new({ address_1: '33 N str', city: 'New York', state: 'NY', zip_code: '132' })

  order = AlphaCard::Order.new({ orderid: 1, orderdescription: 'Test order' })

  # Format of amount: "XX.XX" ("%.2f" % Float)
  sale = AlphaCard::Sale.new({ ccexp: '0117', ccnumber: '4111111111111111', amount: "1.50", cvv: '123' })
  sale.create(order, account)
rescue AlphaCard::AlphaCardError => e
  puts e.message
  false
end
```

`Billing` and `Shipping` is an _optional_ parameters and can be not specified.

_Note_: take a look at the `amount` of the Order. It's format must be 'xx.xx'. All information about variables formats 
can be found on _Alpha Card Payment Gateway Integration Portal_ -> _Direct Post API_ -> _Documentation_ -> _Transaction Variables_

Naming convention of attributes (such as "ccexp" or "orderid") was saved for compatibility with AlphaCard API.

To raise some exceptions do the next:

*   to cause a declined message, pass an amount less than 1.00;
*   to trigger a fatal error message, pass an invalid card number;
*   to simulate an AVS match, pass 888 in the address1 field, 77777 for zip;
*   to simulate a CVV match, pass 999 in the cvv field.

Example of exception:

```ruby
...
2.1.1 :019 >  sale.create(order, account)
AlphaCard::AlphaCardError: Invalid Credit Card Number REFID:127145481
```

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

Copyright (c) 2014-2016 Nikita Bulaj (bulajnikita@gmail.com).
