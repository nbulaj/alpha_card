Gem::Specification.new do |s|
  s.name = 'alpha_card'
  s.version = '0.1'
  s.date = '2014-06-25'
  s.summary = "Alpha Card DirectPost API"
  s.description = "Gem for creates sales with Alpha Card DirectPost API"
  s.authors = ["Nikita Bulaj"]
  s.email = 'bulajnikita@gmail.com'
  s.files = [
      'lib/alpha_card.rb',
      'lib/alpha_card/object.rb',
      'lib/alpha_card/data/codes.yml',
      'lib/alpha_card/alpha_card_response.rb',
      'lib/alpha_card/alpha_card_error.rb',
      'lib/alpha_card/alpha_card_object.rb',

      'lib/alpha_card/account.rb',
      'lib/alpha_card/billing.rb',
      'lib/alpha_card/order.rb',
      'lib/alpha_card/sale.rb',
      'lib/alpha_card/shipping.rb'
  ]
  s.homepage = 'http://github.com/budev/alpha_card'
  s.license = 'MIT'
end
