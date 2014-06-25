module AlphaCard
  class Sale < AlphaCardObject
    attribute :ccexp, String
    attribute :ccnumber, String
    attribute :amount, String
    attribute :cvv, String

    attribute :type, String, default: 'sale', writer: :private

    def create(order, account)
      [:ccexp, :ccnumber, :amount].each do |attr|
        raise Exception.new("No #{attr.to_s} information provided") if self.send(attr.to_s).blank?
      end

      sale_query = self.to_query
      order_query = order.to_query
      billing_query = order.billing.try(:to_query)
      shipping_query = order.shipping.try(:to_query)

      params = [order_query, billing_query, sale_query, shipping_query].reject(&:blank?).join('&')

      AlphaCard.request(params, account).success?
    end
  end
end