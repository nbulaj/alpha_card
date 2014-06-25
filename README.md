# Ruby lib for creating payments with AlphaCard DirectPost API

This gem can help your ruby/rails application to integrate with AlphaCard service.

AlphaCard: 
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
*   curb (for Curl)
*   virtus (for nice OOP objects of AlphaCard)

### Example

Create AlphaCard sale:

```ruby
account = AlphaCard::Account.new('demo', 'password')

billing = AlphaCard::Billing.new({email: 'test@example.com', phone: '+801311313111'})
shipping = AlphaCard::Shipping.new({address_1: '33 N str', city: 'New York', state: 'NY', zip_code: '132'})

order = AlphaCard::Order.new({orderid: 1, orderdescription: 'Test order'})
order.billing = billing
order.shipping = shipping

sale = AlphaCard::Sale.new({ccexp: '0117', ccnumber: '4111111111111111', amount: "%.2f" % 1.5 , cvv: '123'})
sale.create(order, account)
```

Format of parameters can be found on Alpha Card Payment Gateway Integration Portal -> 
Direct Post API -> Documentation -> Transaction Variables

Naming convention of attributes (such as "ccexp" or "orderid") was saved due to
compatibility with AlphaCard API.

## Copyright

Copyright (c) 2014 Nikita Bulaj (bulajnikita@gmail.com).