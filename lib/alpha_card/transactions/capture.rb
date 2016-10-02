module AlphaCard
  ##
  # Implementation of Alpha Card Services Capture transaction.
  class Capture < Resource
    attribute :transaction_id
    # Format: xx.xx
    attribute :amount
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
      order_id: :orderid
    }.freeze

    ##
    # Creates a Capture transaction.
    #
    # @param credentials [Hash]
    #   Alpha Card merchant account credentials
    #
    # @return [AlphaCard::Response]
    #   AlphaCard Gateway response with all the information about transaction.
    #
    # @raise [AlphaCard::InvalidObjectError]
    #   Exception if one of required attributes doesn't specified.
    #
    # @example
    #   capture = AlphaCard::Capture.new(transaction_id: '981562', amount: '10.05')
    #   capture.process
    #
    #   #=> #<AlphaCard::Response:0x1a0fda ...>
    def process(credentials = Account.credentials)
      abort_if_attributes_blank!(:amount, :transaction_id)

      AlphaCard.request(attributes_for_request, credentials)
    end

    alias create process
  end
end
