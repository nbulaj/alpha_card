module AlphaCard
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
    attribute :website, String
  end
end