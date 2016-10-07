module AlphaCard
  ##
  # AlphaCard resource attributes format error
  class InvalidAttributeFormat < StandardError
    # Exception constructor. Returns an error with message about wrong
    # attribute format.
    #
    # @param value [Object] current attribute value
    # @param format [Regexp] required format
    def initialize(value, format)
      super("'#{value}' does not match the '#{format.inspect}' format")
    end
  end
end
