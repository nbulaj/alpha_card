module AlphaCard
  ##
  # Implementation of Alpha Card Services Sale transaction.
  # Contains all the information about Customer Credit Card,
  # such as CVV, number, expiration date, etc.
  # Process the Alpha Card Services payment.
  class Sale < Resource
    # Format: MMYY
    attribute :card_expiration_date, format: /\d{4}/
    attribute :card_number
    attribute :amount
    attribute :cvv
    # Values: 'true' or 'false'
    attribute :customer_receipt
    attribute :check_name
    attribute :check_aba
    attribute :check_account
    # Values: 'business' or 'personal'
    attribute :account_holder_type, values: %w(business personal).freeze
    # Values: 'checking' or 'savings'
    attribute :account_type, values: %w(checking savings).freeze
    # Values: 'PPD', 'WEB', 'TEL', or 'CCD'
    attribute :sec_code, values: %w(PPD WEB TEL CCD).freeze

    ##
    # Payment type.
    # Values: 'creditcard' or 'check'
    attribute :payment, default: 'creditcard', values: %w(creditcard check).freeze

    ##
    # Transaction type (default is 'sale')
    #
    # @attribute [r] type
    attribute :type, default: 'sale', writeable: false

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
    # @param order [AlphaCard::Order]
    #    An <code>AlphaCard::Order</code> object.
    #
    # @param credentials [Hash]
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
    # @param order [AlphaCard::Order]
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
