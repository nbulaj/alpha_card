# frozen_string_literal: true

# typed: true
module AlphaCard
  ##
  # AlphaCard resource attributes value error
  class InvalidAttributeType < StandardError
    # Exception constructor. Returns an error with message about
    # wrong attribute value type.
    #
    # @param value [Object] current attribute value
    # @param types [Array] possible attribute types
    def initialize(value, types)
      super("'#{value}' must be an instance of #{types.join(', ')}")
    end
  end
end
