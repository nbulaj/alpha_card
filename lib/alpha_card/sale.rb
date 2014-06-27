module AlphaCard
  ##
  # Implementation of Alpha Card Services Sale object.
  # Contains all the information about Customer Credit Card,
  # such as CVV, number, expiration date, etc.
  # Process the Alpha Card Services payment.
  class Sale < AlphaCardObject
    attribute :ccexp, String
    attribute :ccnumber, String
    attribute :amount, String
    attribute :cvv, String

    ##
    # Not writable attribute, defines the type of transaction (default is 'sale')
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
    #   order = AlphaCard::Order.new({orderid: 1, orderdescription: 'Test order'})
    #   sale = AlphaCard::Sale.new({ccexp: '0117', ccnumber: '4111111111111111', amount: "5.00" })
    #   sale.create(order, account)
    #
    #   #=> true
    def create(order, account)
      [:ccexp, :ccnumber, :amount].each do |attr|
        raise Exception.new("No #{attr} information provided") if self[attr].blank?
      end

      params = self.filled_attributes || {}
      [order, order.billing, order.shipping].compact.each { |obj| params.merge!(obj.try(:filled_attributes)) }

      AlphaCard.request(params, account).success?
    end
  end
end