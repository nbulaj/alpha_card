module AlphaCard
  ##
  # Implementation of Alpha Card Services Void transaction.
  class Void < Resource
    attribute :transaction_id, String

    ##
    # Transaction type (default is 'void')
    #
    # @attribute [r] type
    attribute :type, String, default: 'void', writer: :private

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      transaction_id: :transactionid
    }.freeze

    ##
    # Creates void transaction with the <code>AlphaCard::Account</code> credentials.
    #
    # @param [AlphaCard::Account] account
    #   An <code>AlphaCard::Account</code> object.
    #
    # @return [Boolean]
    #   True if transaction was created successfully.
    #   Raise an AlphaCardError exception if some error occurred.
    #
    # @raise [AlphaCard::InvalidObjectError]
    #   Exception if one of required attributes doesn't specified.
    #
    # @example
    #   account = AlphaCard::Account.new('demo', 'password')
    #   void = AlphaCard::Void.new(transaction_id: '981562')
    #   void.create(account)
    #
    #   #=> [true, #<AlphaCard::Response:0x1a0fda ...>]
    def process(credentials = Account.credentials)
      abort_if_attributes_blank!(:transaction_id)

      response = AlphaCard.request(attributes_for_request, credentials)
      [response.success?, response]
    end

    alias create process
  end
end
