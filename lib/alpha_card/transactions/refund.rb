module AlphaCard
  ##
  # Implementation of Alpha Card Services Refund transaction.
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
      transaction_id: :transactionid
    }.freeze
  end
end
