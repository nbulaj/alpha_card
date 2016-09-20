module AlphaCard
  ##
  # Implementation of Alpha Card Services Refund object.
  class Refund < Void
    # Format: xx.xx
    attribute :amount, String

    ##
    # The type of transaction (default is 'refund')
    #
    # @attribute [r] type
    attribute :type, String, default: 'refund', writer: :private
  end
end
