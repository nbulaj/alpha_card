module AlphaCard
  ##
  # Implementation of Alpha Card Services Authorization transaction.
  class Auth < Sale
    ##
    # Transaction type (default is 'auth')
    #
    # @attribute [r] type
    attribute :type, default: 'auth', writable: false
  end
end
