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
    # Creates void transaction.
    #
    # @param [Hash] credentials
    #   Alpha Card merchant account credentials.
    #
    # @return [AlphaCard::Response]
    #   AlphaCard Gateway response with all the information about transaction.
    #
    # @raise [AlphaCard::InvalidObjectError]
    #   Exception if one of required attributes doesn't specified.
    #
    # @example
    #   void = AlphaCard::Void.new(transaction_id: '981562')
    #   void.create
    #
    #   #=> [true, #<AlphaCard::Response:0x1a0fda ...>]
    def process(credentials = Account.credentials)
      abort_if_attributes_blank!(:transaction_id)

      AlphaCard.request(attributes_for_request, credentials)
    end

    alias create process
  end
end
