# frozen_string_literal: true

# typed: true
module AlphaCard
  ##
  # Implementation of Alpha Card Services Refund transaction.
  #
  # @example
  #   refund = AlphaCard::Refund.new(transaction_id: '981562', amount: '1.00')
  #   refund.create
  #
  #   #=> #<AlphaCard::Response:0x1a0fda ...>
  #
  class Refund < Void
    # Format: xx.xx
    attribute :amount

    ##
    # Transaction type (default is 'refund')
    #
    # @attribute [r] type
    attribute :type, default: 'refund', writable: false

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      transaction_id: :transactionid,
    }.freeze
  end
end
