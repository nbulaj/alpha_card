module AlphaCard
  class Sale < AlphaCardObject
    attribute :ccexp, String
    attribute :ccnumber, String
    attribute :amount, String
    attribute :cvv, String

    # Not writable attribute, define the type of transaction (default is 'sale')
    attribute :type, String, default: 'sale', writer: :private

    # create(order, account) -> true
    # create(order, account) -> false
    # create(order, account) -> Exception
    #
    # Creates the sale for the <i>order</i> with specified
    # attributes, such as <i>ccexp</i>, <i>ccnumber</i>, <i>amount</i>
    # and <i>cvv</i>.
    #
    #    attrs = {ccexp: '0117', ccnumber: '123', amount: '10.00'}
    #    sale = AlphaCard::Sale.new(attrs)
    #    sale.create(order, account) #=> true or false
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