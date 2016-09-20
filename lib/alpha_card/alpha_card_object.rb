module AlphaCard
  ##
  # Parent class for each Alpha Card Gateway object, such as
  # Order, Billing, Sale and others.
  class AlphaCardObject
    include Virtus.model(nullify_blank: true)

    ##
    # Returns the <code>Hash</code> with only filled attributes
    # of the <code>AlphaCard::AlphaCardObject</code>.
    #
    # @return [Hash]
    #   Filled attributes of the <code>AlphaCard::AlphaCardObject</code>.
    #
    # @example
    #   order = AlphaCard::Order.new(orderid: '1', tax: nil, ponumber: 'PO123')
    #   order.filled_attributes
    #
    #   #=> { orderid: '1', ponumber: 'PO123' }
    def filled_attributes
      attributes.select { |_, value| !value.nil? }
    end

    private

    ##
    # Validate passed attributes for presence. Raises an exception
    # if one of the attribute is not specified.
    #
    # @param [Array] attributes
    #   array of attributes to check
    def abort_if_attributes_blank!(*attributes)
      attributes.each do |attr|
        raise InvalidObjectError, "#{attr} must be present!" if self[attr].nil? || self[attr].empty?
      end
    end
  end
end
