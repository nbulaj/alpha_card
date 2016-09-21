module AlphaCard
  ##
  # Implementation of Alpha Card Services Sale transaction.
  # Contains all the information about Customer Credit Card,
  # such as CVV, number, expiration date, etc.
  # Process the Alpha Card Services payment.
  class Sale < AlphaCardObject
    # Format: MMYY
    attribute :ccexp, String
    attribute :ccnumber, String
    attribute :amount, String
    attribute :cvv, String
    # Values: 'true' or 'false'
    attribute :customer_receipt, String

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
    # Creates the sale for the specified <code>AlphaCard::Order</code>
    # with the <code>AlphaCard::Account</code> credentials.
    #
    # @param [AlphaCard::Order] params
    #    An <code>AlphaCard::Order</code> object.
    # @param [AlphaCard::Account] account
    #   An <code>AlphaCard::Account</code> object.
    #
    # @return [Boolean]
    #   True if sale was created successfully.
    #   Raise an AlphaCardError exception if some error occurred.
    #
    # @raise [AlphaCard::InvalidObjectError]
    #   Exception if one of required attributes doesn't specified.
    #
    # @example
    #   account = AlphaCard::Account.new('demo', 'password')
    #   order = AlphaCard::Order.new(orderid: 1, orderdescription: 'Test order')
    #   sale = AlphaCard::Sale.new(ccexp: '0117', ccnumber: '4111111111111111', amount: "5.00" )
    #   sale.create(order, account)
    #
    #   #=> true
    def create(order, account)
      abort_if_attributes_blank!(:ccexp, :ccnumber, :amount)

      AlphaCard.request(account, params_for_sale(order)).success?
    end

    private

    ##
    # Return params for Alpha Card Sale request
    #
    # @param [AlphaCard::Order] order
    #    An <code>AlphaCard::Order</code> object.
    #
    # @return [Hash]
    #   Params of *self* object merged with params
    #   of another object (<code>AlphaCard::Order</code>)
    def params_for_sale(order)
      request_params = filled_attributes || {}

      [order, order.billing, order.shipping].compact.each do |obj|
        request_params.merge!(obj.filled_attributes)
      end

      request_params
    end
  end
end
