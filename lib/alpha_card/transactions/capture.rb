module AlphaCard
  ##
  # Implementation of Alpha Card Services Capture transaction.
  class Capture < AlphaCardObject
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
    # Creates a Capture with the <code>AlphaCard::Account</code> credentials.
    #
    # @param [AlphaCard::Account] account
    #   An <code>AlphaCard::Account</code> object.
    #
    # @return [Boolean]
    #   True if capture was created successfully.
    #   Raise an AlphaCardError exception if some error occurred.
    #
    # @raise [Exception]
    #   Exception if one of required attributes doesn't specified.
    #
    # @example
    #   account = AlphaCard::Account.new('demo', 'password')
    #   capture = AlphaCard::Capture.new(transaction_id: '981562', amount: '10.05')
    #   capture.create(account)
    #
    #   #=> [true, #<AlphaCard::AlphaCardResponse:0x1a0fda ...>]
    def create(account)
      abort_if_attributes_blank!(:amount, :transaction_id)

      response = AlphaCard.request(account, attributes_for_request)
      [response.success?, response]
    end
  end
end
