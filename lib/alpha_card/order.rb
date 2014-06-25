module AlphaCard
  class Order < AlphaCardObject
    attribute :orderid, Integer
    attribute :orderdescription, String
    attribute :ponumber, String

    attr_accessor :billing, :shipping
  end
end