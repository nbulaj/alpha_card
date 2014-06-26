# Ruby lib for creating payments with AlphaCard DirectPost API
[![Gem Version](https://badge.fury.io/rb/alpha_card.svg)](http://badge.fury.io/rb/alpha_card)
[![Dependency Status](https://gemnasium.com/budev/alpha_card.png)](https://gemnasium.com/budev/alpha_card)
[![Code Climate](https://codeclimate.com/github/NoamB/sorcery.png)](https://codeclimate.com/github/NoamB/sorcery)

This gem can help your ruby/rails application to integrate with AlphaCard service.

AlphaCard Services: 
http://www.alphacardservices.com/
     
Payment Gateway Integration Portal:
https://secure.alphacardgateway.com/merchants/resources/integration/integration_portal.php


## Installation

If using bundler, first add 'alpha_card' to your Gemfile:

```ruby
gem "alpha_card"
```

And run

```sh
bundle install
```

Otherwise simply

```sh
gem install alpha_card
```

Dependencies required:

*   ruby >= 1.9.3
*   rest_client
*   virtus (for nice OOP objects of AlphaCard)

## Objects

To create sale with Alpha Card Services you must operate with 5 objects:

*   Account
*   Order
    - Billing
    - Shipping
*   Sale

### Account

Specify credentials to access Alpha Card Services, Inc.

_Required fields_:

*   username : String
*   password : String

_Constructor_:

```ruby
AlphaCard::Account.new(username, password)
```

### Order

Specify Order.

_Required fields_:

*   orderid : String
*   orderdescription : String

_Unnecessary fields_:

*   ponumber : String
*   billing : AlphaCard::Billing
*   shipping : AlphaCard::Shipping

_Constructor_:

```ruby
AlphaCard::Order.new({field_name: value, ...})
```

Set up billing or shipping:

```ruby
order = AlphaCard::Order.new({})
order.shipping = AlphaCard::Shipping.new({})
order.billing = AlphaCard::Billing.new({})
```

### Billing

Specify Billing information for Order.

_Unnecessary fields_:

*   firstname : String
*   lastname : String
*   email : String
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
AlphaCard::Billing.new({field_name: value, ...})
```

### Shipping

Specify Shipping information for Order.

_Unnecessary fields_:

*   address_1 : String
*   address_2 : String
*   city : String
*   state : String
*   zip_code : String
*   email : String

_Constructor_:

```ruby
AlphaCard::Shipping.new({field_name: value, ...})
```

### Sale

Specify and process Order payment information.

_Required fields_:

*   ccexp : String
*   ccnumber : String
*   amount : String

_Unnecessary fields_:
*   cvv : String

_Constructor_:

```ruby
AlphaCard::Sale.new({field_name: value, ...})
```

To process the sale you must call *create(_alpha_card_order_, _alpha_card_account_)*:

```ruby
...
sale = AlphaCard::Sale.new({})
sale.create(order, account)
```

Method `create` returns _true_ if sale was created successfully and raise an `AlphaCardError` 
exception if some of the fields is invalid.

## Example of usage

Create AlphaCard sale:

```ruby
require 'alpha_card'

def create_payment
  account = AlphaCard::Account.new('demo', 'password')

  billing = AlphaCard::Billing.new({email: 'test@example.com', phone: '+801311313111'})
  shipping = AlphaCard::Shipping.new({address_1: '33 N str', city: 'New York', state: 'NY', zip_code: '132'})

  order = AlphaCard::Order.new({orderid: 1, orderdescription: 'Test order'})
  order.billing = billing
  order.shipping = shipping

  sale = AlphaCard::Sale.new({ccexp: '0117', ccnumber: '4111111111111111', amount: "%.2f" % 1.5 , cvv: '123'})
  sale.create(order, account)
rescue AlphaCard::AlphaCardError => e
  puts e.message
  false
end
```

`Billing` and `shipping` is an _optional_ parameters and can be not specified.

_Note_: take a look to the `amount` of the Order. It's format must be 'xx.xx'. All information about formats 
can be found on _Alpha Card Payment Gateway Integration Portal_ -> _Direct Post API_ -> _Documentation_ -> _Transaction Variables_

Naming convention of attributes (such as "ccexp" or "orderid") was saved due to compatibility with AlphaCard API.

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

1. Fork the project
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes
4. Add tests
5. Run `rake` to make sure all tests pass
6. Commit your changes (`git commit -am 'Add new feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new pull request

Thanks.

## Copyright

Copyright (c) 2014 Nikita Bulaj (bulajnikita@gmail.com).