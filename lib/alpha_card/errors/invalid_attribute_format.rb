module AlphaCard
  ##
  # AlphaCard resource attributes format error
  class InvalidAttributeFormat < StandardError
    def initialize(value, format)
      super("'#{value}' does not match the '#{format.inspect}' format")
    end
  end
end
