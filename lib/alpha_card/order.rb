module AlphaCard
  class Order < AlphaCardObject
    attribute :orderid, Integer
    attribute :orderdescription, String
    attribute :ponumber, String

    attribute :billing, AlphaCard::Billing
    attribute :shipping, AlphaCard::Shipping
  end
end