# frozen_string_literal: true

# typed: true
module AlphaCard
  ##
  # Implementation of Alpha Card Services Capture transaction.
  #
  # @example
  #   capture = AlphaCard::Capture.new(transaction_id: '981562', amount: '10.05')
  #   capture.process
  #
  #   #=> #<AlphaCard::Response:0x1a0fda ...>
  #
  class Capture < Transaction
    attribute :transaction_id, required: true
    # Format: xx.xx
    attribute :amount, required: true
    attribute :tracking_number
    attribute :shipping_carrier
    attribute :order_id

    ##
    # Transaction type (default is 'capture')
    #
    # @attribute [r] type
    attribute :type, default: 'capture', writeable: false

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      transaction_id: :transactionid,
      order_id: :orderid,
    }.freeze
  end
end
