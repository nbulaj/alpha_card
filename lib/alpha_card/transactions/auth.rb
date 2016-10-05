module AlphaCard
  ##
  # Implementation of Alpha Card Services Authorization transaction.
  #
  # @example
  #   auth = AlphaCard::Auth.new(card_expiration_date: '0117', card_number: '4111111111111111', amount: '1.00')
  #   auth.create(order)
  #
  #   #=> #<AlphaCard::Response:0x1a0fda ...>
  #
  class Auth < Sale
    ##
    # Transaction type (default is 'auth')
    #
    # @attribute [r] type
    attribute :type, default: 'auth', writable: false
  end
end
