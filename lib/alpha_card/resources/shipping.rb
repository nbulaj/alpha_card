module AlphaCard
  ##
  # Implementation of Alpha Card Services order shipping information.
  # Contains all the shipping information (address, city, zip, etc).
  class Shipping < Resource
    attribute :first_name, String
    attribute :last_name, String
    attribute :company, String
    attribute :address_1, String
    attribute :address_2, String
    attribute :city, String
    attribute :state, String
    attribute :zip_code, String
    attribute :country, String
    attribute :email, String

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      first_name: :firstname,
      last_name: :lastname,
      address_1: :address1,
      address_2: :address2
    }.freeze

    protected

    ##
    # Overloaded <code>filled_attributes</code> method from
    # <code>AlphaCard::AlphaCardObject</code>. All attribute names of
    # the Alpha Card Shipping object must start with "shipping_"
    # prefix.
    #
    # @return [Hash] attributes
    #   Only filled attributes of Shipping resource with "shipping_" prefix.
    #
    # @example
    #   shipping = AlphaCard::Shipping.new(first_name: 'John', state: 'NY')
    #   shipping.filled_attributes
    #
    #   #=> { shipping_firstname: 'John', shipping_state: 'NY' }
    def filled_attributes
      Hash[super.map { |k, v| ["shipping_#{k}".to_sym, v] }]
    end
  end
end
