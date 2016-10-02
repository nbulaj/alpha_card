module AlphaCard
  ##
  # AlphaCard resource attributes format error
  class InvalidAttributeFormat < StandardError
    def initialize(value)
      @value = value
    end
  end
end
