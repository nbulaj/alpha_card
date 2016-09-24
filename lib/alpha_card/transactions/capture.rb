module AlphaCard
  ##
  # Implementation of Alpha Card Services Capture transaction.
  class Capture < Resource
    attribute :transaction_id, String
    # Format: xx.xx
    attribute :amount, String
    attribute :tracking_number, String
    attribute :shipping_carrier, String
    attribute :order_id, String

    ##
    # Transaction type (default is 'capture')
    #
    # @attribute [r] type
    attribute :type, String, default: 'capture', writer: :private

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      transaction_id: :transactionid,
      order_id: :orderid
    }.freeze

    ##
    # Creates a Capture transaction.
    #
    # @param [Hash] credentials
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
