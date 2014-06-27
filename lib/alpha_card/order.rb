module AlphaCard
  ##
  # Implementation of Alpha Card Services Order object.
  # Contains all the information about order (id, description, etc).
  class Order < AlphaCardObject
    attribute :orderid, Integer
    attribute :orderdescription, String
    attribute :ponumber, String
    attribute :tax, String

    attribute :billing, AlphaCard::Billing
    attribute :shipping, AlphaCard::Shipping
  end
end