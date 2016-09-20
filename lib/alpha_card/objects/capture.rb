module AlphaCard
  ##
  # Implementation of Alpha Card Services Capture object.
  class Capture < AlphaCardObject
    attribute :transactionid, String
    # Format: xx.xx
    attribute :amount, String
    attribute :tracking_number, String
    attribute :shipping_carrier, String
    attribute :orderid, String

    ##
    # Transaction type (default is 'capture')
    #
    # @attribute [r] type
    attribute :type, String, default: 'capture', writer: :private

    ##
    # Creates a Capture with the <code>AlphaCard::Account</code> credentials.
    #
    # @param [AlphaCard::Account] account
    #   An <code>AlphaCard::Account</code> object.
    #
    # @return [Boolean]
    #   True if capture was created successfully.
    #   Raise an AlphaCardError exception if some error occurred.
    #
    # @raise [Exception]
    #   Exception if one of required attributes doesn't specified.
    #
    # @example
    #   account = AlphaCard::Account.new('demo', 'password')
    #   capture = AlphaCard::Capture.new(transactionid: '981562', amount: '10.05')
    #   capture.create(account)
    #
    #   #=> true
    def create(account)
      abort_if_attributes_blank!(:amount, :transactionid)

      AlphaCard.request(account, filled_attributes)
    end
  end
end
