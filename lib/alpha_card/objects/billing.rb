module AlphaCard
  ##
  # Implementation of Alpha Card Services order billing information.
  # Contains all the billing information (customer name, email, email, etc).
  class Billing < AlphaCardObject
    attribute :firstname, String
    attribute :lastname, String
    attribute :email, String
    attribute :phone, String
    attribute :company, String
    attribute :address1, String
    attribute :address2, String
    attribute :city, String
    attribute :state, String
    attribute :zip, String
    attribute :country, String
    attribute :fax, String
    attribute :website, String
  end
end
