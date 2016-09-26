module AlphaCard
  ##
  # Implementation of Alpha Card Services Credit transaction.
  class Credit < Sale
    ##
    # Transaction type (default is 'credit')
    #
    # @attribute [r] type
    attribute :type, String, default: 'credit', writer: :private
  end
end
