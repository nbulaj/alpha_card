# frozen_string_literal: true

# typed: strict
module AlphaCard
  ##
  # Implementation of Alpha Card Services Validate transaction.
  #
  # @example
  #   validate = AlphaCard::Validate.new(card_expiration_date: '0117', card_number: '4111111111111111')
  #   validate.process
  #
  #   #=> #<AlphaCard::Response:0x1a0fda ...>
  #
  class Validate < Sale
    ##
    # Transaction type (default is 'validate')
    #
    # @attribute [r] type
    attribute :type, default: 'validate', writable: false

    # Validate transaction can't have an amount
    remove_attribute :amount
  end
end
