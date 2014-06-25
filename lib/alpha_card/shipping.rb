module AlphaCard
  class Shipping < AlphaCardObject
    attribute :address_1, String
    attribute :address_2, String
    attribute :city, String
    attribute :state, String
    attribute :zip_code, String
    attribute :email, String
  end
end