module AlphaCard
  class AlphaCardObject
    include Virtus.model

    # filled_attributes -> Hash
    #
    # Returns only filled attributes, not nil ones.
    #
    #    order = AlphaCard::Order.new({})
    #    order.filled_attributes #=> {}

    #    order = AlphaCard::Order.new({orderid: '1'})
    #    order.filled_attributes #=> {orderid: '1'}
    def filled_attributes
      self.attributes.select { |key, value| value.present? }
    end
  end
end