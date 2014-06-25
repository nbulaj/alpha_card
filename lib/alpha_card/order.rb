module AlphaCard
  class Order < AlphaCardObject
    attribute :orderid, Integer
    attribute :orderdescription, String

    attr_accessor :billing, :shipping
  end
end