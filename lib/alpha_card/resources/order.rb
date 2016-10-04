module AlphaCard
  ##
  # Implementation of Alpha Card Services Order object.
  # Contains all the information about order (id, description, etc).
  class Order < Resource
    attribute :id
    attribute :description
    attribute :po_number
    attribute :tax
    # Format: xxx.xxx.xxx.xxx
    attribute :ip_address, format: /\A(?:[0-9]{1,3}\.){3}[0-9]{1,3}\z/.freeze

    attribute :billing
    attribute :shipping

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      id: :orderid,
      description: :orderdescription,
      po_number: :ponumber,
      ip_address: :ipaddress
    }.freeze

    ##
    # Overloaded method to return all the attributes from the
    # sale + billing + shipping objects.
    #
    # @return [Hash]
    #   Filled attributes with the original Alpha Card Services
    #   transaction variables names.
    #
    # @example
    #   billing = AlphaCard::Billing.new(email: 'test@example.com')
    #   shipping = AlphaCard::Shipping.new(first_name: 'John', last_name: 'Doe')
    #   order = AlphaCard::Order.new(id: '1', billing: billing, shipping: shipping)
    #   order.attributes_for_request
    #
    #   #=>  { orderid: '1', email: 'test@example.com', shipping_first_name: 'John', shipping_last_name: 'Doe' }
    def attributes_for_request(*)
      attributes = filled_attributes.dup

      billing = attributes.delete(:billing)
      attributes.merge!(billing.attributes_for_request) if billing

      shipping = attributes.delete(:shipping)
      attributes.merge!(shipping.attributes_for_request) if shipping

      super(attributes)
    end
  end
end
