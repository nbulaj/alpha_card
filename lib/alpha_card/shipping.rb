module AlphaCard
  ##
  # Implementation of Alpha Card Services order shipping information.
  # Contains all the shipping information (address, city, zip, etc).
  class Shipping < AlphaCardObject
    attribute :firstname, String
    attribute :lastname, String
    attribute :company, String
    attribute :address_1, String
    attribute :address_2, String
    attribute :city, String
    attribute :state, String
    attribute :zip_code, String
    attribute :country, String
    attribute :email, String
  end
end