# frozen_string_literal: true

# typed: true
module AlphaCard
  ##
  # Implementation of Alpha Card Services order shipping information.
  # Contains all the shipping information (address, city, zip, etc).
  class Shipping < Resource
    attribute :first_name, type: String
    attribute :last_name, type: String
    attribute :company, type: String
    attribute :address_1, type: String
    attribute :address_2, type: String
    attribute :city, type: String
    # Format: 'CC'
    attribute :state, type: String, format: /\A[A-Za-z]{2}\z/.freeze
    attribute :zip_code, type: String
    # Format: 'CC'
    attribute :country, type: String, format: /\A[A-Za-z]{2}\z/.freeze
    attribute :email, type: String

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      first_name: :firstname,
      last_name: :lastname,
      address_1: :address1,
      address_2: :address2,
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
