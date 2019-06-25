# frozen_string_literal: true

# typed: strict
module AlphaCard
  ##
  # Implementation of Alpha Card Services Credit transaction.
  #
  # @example
  #   credit = AlphaCard::Credit.new(card_expiration_date: '0117', card_number: '4111111111111111', amount: '1.00')
  #   credit.create(order)
  #
  #   #=> #<AlphaCard::Response:0x1a0fda ...>
  #
  class Credit < Sale
    ##
    # Transaction type (default is 'credit')
    #
    # @attribute [r] type
    attribute :type, default: 'credit', writable: false
  end
end
