module AlphaCard
  ##
  # Implementation of Alpha Card Services Sale object.
  # Contains all the information about Customer Credit Card,
  # such as CVV, number, expiration date, etc.
  # Process the Alpha Card Services payment.
  class Sale < AlphaCardObject
    # Format: MMYY
    attribute :ccexp, String
    attribute :ccnumber, String
    attribute :amount, String
    attribute :cvv, String

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
    # @raise [Exception]
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

      AlphaCard.request(account, order_params(order)).success?
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
    def order_params(order)
      params = filled_attributes || {}

      [order, order.billing, order.shipping].compact.each do |obj|
        params.merge!(obj.filled_attributes)
      end

      params
    end
  end
end
