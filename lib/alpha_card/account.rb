module AlphaCard
  # AlphaCard Account class for global credentials settings
  class Account
    class << self
      # Global Alpha Card Merchant account credentials
      attr_accessor :username, :password

      ##
      # Setups demo Alpha Card credentials
      def use_demo_credentials!
        self.username = 'demo'
        self.password = 'password'
      end

      ##
      # Checks credentials not to be nil or empty string
      def valid_credentials?(credentials)
        !credentials[:username].to_s.empty? && !credentials[:password].to_s.empty?
      end

      ##
      # Returns hash with Alpha Card credentials
      #
      # @return [Hash] credentials
      def credentials
        { username: username, password: password }
      end
    end
  end
end
