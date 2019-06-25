# frozen_string_literal: true

# typed: true
module AlphaCard
  ##
  # Base Alpha Card transaction object.
  class Transaction < Resource
    ##
    # Creates transaction.
    #
    # @param credentials [Hash]
    #   Alpha Card merchant account credentials.
    #
    # @return [AlphaCard::Response]
    #   AlphaCard Gateway response with all the information about transaction.
    #
    # @raise [AlphaCard::InvalidObjectError]
    #   Exception if one of required attributes doesn't specified.
    #
    # @example
    #   void = AlphaCard::Void.new(transaction_id: '981562')
    #   void.create
    #
    #   #=> #<AlphaCard::Response:0x1a0fda ...>
    def process(credentials = Account.credentials)
      validate_required_attributes!

      AlphaCard.request(attributes_for_request, credentials)
    end

    alias create process
  end
end
