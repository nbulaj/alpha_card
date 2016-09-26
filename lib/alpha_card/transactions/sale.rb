module AlphaCard
  ##
  # Implementation of Alpha Card Services Sale transaction.
  # Contains all the information about Customer Credit Card,
  # such as CVV, number, expiration date, etc.
  # Process the Alpha Card Services payment.
  class Sale < Resource
    # Format: MMYY
    attribute :card_expiration_date, String
    attribute :card_number, String
    attribute :amount, String
    attribute :cvv, String
    # Values: 'true' or 'false'
    attribute :customer_receipt, String
    attribute :check_name, String
    attribute :check_aba, String
    attribute :check_account, String
    # Values: 'business' or 'personal'
    attribute :account_holder_type, String
    # Values: 'checking' or 'savings'
    attribute :account_type, String
    # Values: 'PPD', 'WEB', 'TEL', or 'CCD'
    attribute :sec_code, String

    ##
    # Payment type.
    # Values: 'creditcard' or 'check'
    attribute :payment, String, default: 'creditcard'

    ##
    # Transaction type (default is 'sale')
    #
    # @attribute [r] type
    attribute :type, String, default: 'sale', writer: :private

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      card_expiration_date: :ccexp,
      card_number: :ccnumber,
      check_name: :checkname,
      check_aba: :checkaba,
      check_account: :checkaccount
    }.freeze

    ##
    # Creates the sale transaction for the specified <code>AlphaCard::Order</code>.
    #
    # @param [AlphaCard::Order] order
    #    An <code>AlphaCard::Order</code> object.
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
    #   order = AlphaCard::Order.new(id: 1, description: 'Test order')
    #   sale = AlphaCard::Sale.new(card_expiration_date: '0117', card_number: '4111111111111111', amount: '5.00' )
    #   sale.create(order)
    #
    #   #=> #<AlphaCard::Response:0x1a0fda ...>
    def process(order, credentials = Account.credentials)
      abort_if_attributes_blank!(:card_expiration_date, :card_number, :amount)

      AlphaCard.request(params_for_sale(order), credentials)
    end

    alias create process

    private

    ##
    # Returns all the necessary attributes with it's original
    # names that must be passed with Sale transaction.
    #
    # @param [AlphaCard::Order] order
    #    An <code>AlphaCard::Order</code> object.
    #
    # @return [Hash]
    #   Params of *self* object merged with params
    #   of another object (<code>AlphaCard::Order</code>)
    def params_for_sale(order)
      attributes_for_request.merge(order.attributes_for_request)
    end
  end
end
