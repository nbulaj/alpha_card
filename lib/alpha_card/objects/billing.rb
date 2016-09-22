module AlphaCard
  ##
  # Implementation of Alpha Card Services order billing information.
  # Contains all the billing information (customer name, email, email, etc).
  class Billing < AlphaCardObject
    attribute :first_name, String
    attribute :last_name, String
    attribute :email, String
    attribute :phone, String
    attribute :company, String
    attribute :address_1, String
    attribute :address_2, String
    attribute :city, String
    attribute :state, String
    attribute :zip, String
    attribute :country, String
    attribute :fax, String
    attribute :website, String

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      first_name: :firstname,
      last_name: :lastname,
      address_1: :address1,
      address_2: :address2
    }.freeze

    deprecate_old_variables!
  end
end
