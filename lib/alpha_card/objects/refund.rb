module AlphaCard
  ##
  # Implementation of Alpha Card Services Refund transaction.
  class Refund < Void
    # Format: xx.xx
    attribute :amount, String

    ##
    # Transaction type (default is 'refund')
    #
    # @attribute [r] type
    attribute :type, String, default: 'refund', writer: :private
  end
end
