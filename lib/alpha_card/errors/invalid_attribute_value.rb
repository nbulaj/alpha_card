module AlphaCard
  ##
  # AlphaCard resource attributes error
  class InvalidAttributeValue < StandardError
    def initialize(value, values)
      @value = value
      @values = values
    end
  end
end
