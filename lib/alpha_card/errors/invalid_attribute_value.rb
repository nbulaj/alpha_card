module AlphaCard
  ##
  # AlphaCard resource attributes value error
  class InvalidAttributeValue < StandardError
    # Exception constructor. Returns an error with message about wrong value
    # and possible values.
    #
    # @param value [Object] current attribute value
    # @param values [Array] possible attribute values
    def initialize(value, values)
      super("'#{value}' is invalid attribute value. Use one from the following: #{values.join(', ')}")
    end
  end
end
