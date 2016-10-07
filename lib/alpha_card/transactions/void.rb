module AlphaCard
  ##
  # Implementation of Alpha Card Services Void transaction.
  #
  # @example
  #   void = AlphaCard::Void.new(transaction_id: '981562')
  #   void.create
  #
  #   #=> #<AlphaCard::Response:0x1a0fda ...>
  #
  class Void < Transaction
    attribute :transaction_id, type: [String, Integer], required: true

    ##
    # Transaction type (default is 'void')
    #
    # @attribute [r] type
    attribute :type, default: 'void', writable: false

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      transaction_id: :transactionid
    }.freeze
  end
end
