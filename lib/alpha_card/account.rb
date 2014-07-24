module AlphaCard
  ##
  # Implementation of Alpha Card Services account object.
  # Contains credentials (username and password) for
  # the Alpha Card Gateway API access.
  class Account < AlphaCardObject
    attribute :username, String
    attribute :password, String

    ##
    # <code>AlphaCard::Account</code> constructor.
    #
    # @param [String] username
    # @param [String] password
    #
    # @example
    #   AlphaCard::Account.new('demo', 'password')
    #
    #   #=> #<AlphaCard::Account:0x000000039b18a8 @username="demo", @password="password">
    def initialize(username, password)
      self.username = username
      self.password = password
    end

    ##
    # Say if all the credentials of Account is filled.
    # Username and password can't be a <code>nil</code>
    # object or an empty <code>String</code>.
    #
    # @return [Boolean]
    #   True if username and password is filled.
    #
    # @example
    #   account = AlphaCard::Account.new('demo', 'password')
    #   account.filled?
    #
    #   #=> true
    #
    #   account = AlphaCard::Account.new('', nil)
    #   account.filled?
    #
    #   #=> false
    def filled?
      attrs = [username, password]
      !attrs.empty? && attrs.all? { |attr| attr && !attr.strip.empty? }
    end
  end
end
