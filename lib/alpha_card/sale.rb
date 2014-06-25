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

      params = self.filled_attributes || {}
      [order, order.billing, order.shipping].compact.each { |obj| params.merge!(obj.try(:filled_attributes)) }

      AlphaCard.request(params, account).success?
    end
  end
end