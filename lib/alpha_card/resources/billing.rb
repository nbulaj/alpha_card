module AlphaCard
  ##
  # Implementation of Alpha Card Services order billing information.
  # Contains all the billing information (customer name, email, email, etc).
  class Billing < Resource
    attribute :first_name
    attribute :last_name
    attribute :email
    attribute :phone
    attribute :company
    attribute :address_1
    attribute :address_2
    attribute :city
    attribute :state, format: /\A[A-Za-z]{2}\z/.freeze
    attribute :zip
    attribute :country, format: /\A[A-Za-z]{2}\z/.freeze
    attribute :fax
    attribute :website

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      first_name: :firstname,
      last_name: :lastname,
      address_1: :address1,
      address_2: :address2
    }.freeze
  end
end
