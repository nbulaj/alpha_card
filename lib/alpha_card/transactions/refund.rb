module AlphaCard
  ##
  # Implementation of Alpha Card Services Refund transaction.
  class Refund < Void
    # Format: xx.xx
    attribute :amount, String

    ##
    # Transaction type (default is 'refund')
    #
    # @attribute [r] type
    attribute :type, String, default: 'refund', writer: :private

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      transaction_id: :transactionid
    }.freeze
  end
end
