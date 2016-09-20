module AlphaCard
  ##
  # Implementation of Alpha Card Services Void object.
  class Void < AlphaCardObject
    attribute :transactionid, String
    # Format: xx.xx
    attribute :amount, String

    ##
    # Transaction type (default is 'void')
    #
    # @attribute [r] type
    attribute :type, String, default: 'void', writer: :private

    ##
    # Creates refund with the <code>AlphaCard::Account</code> credentials.
    #
    # @param [AlphaCard::Account] account
    #   An <code>AlphaCard::Account</code> object.
    #
    # @return [Boolean]
    #   True if refund was created successfully.
    #   Raise an AlphaCardError exception if some error occurred.
    #
    # @raise [Exception]
    #   Exception if one of required attributes doesn't specified.
    #
    # @example
    #   account = AlphaCard::Account.new('demo', 'password')
    #   void = AlphaCard::Void.new(transactionid: '981562')
    #   void.create(account)
    #
    #   #=> true
    def create(account)
      abort_if_attributes_blank!(:transactionid)

      AlphaCard.request(account, filled_attributes)
    end
  end
end
