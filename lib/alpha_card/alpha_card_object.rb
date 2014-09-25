module AlphaCard
  ##
  # Parent class for each Alpha Card Gateway object, such as
  # Order, Billing, Sale and others.
  class AlphaCardObject
    include Virtus.model

    ##
    # Returns the <code>Hash</code> with only filled attributes
    # of the <code>AlphaCard::AlphaCardObject</code>.
    #
    # @return [Hash]
    #   Filled attributes of the <code>AlphaCard::AlphaCardObject</code>.
    #
    # @example
    #   order = AlphaCard::Order.new({orderid: '1', tax: nil, ponumber: 'PO123'})
    #   order.filled_attributes
    #
    #   #=> {orderid: '1', ponumber: 'PO123'}
    def filled_attributes
      attributes.compact
    end
  end
end
