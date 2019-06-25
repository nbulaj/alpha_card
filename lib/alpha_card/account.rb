# frozen_string_literal: true

# typed: true
#
module AlphaCard
  # AlphaCard Account class for global credentials settings
  class Account
    class << self
      # Global Alpha Card Merchant account credentials
      #
      # @return [String] username
      # @return [String] password
      #
      # @example
      #   AlphaCard::Account.username = 'demo'
      #   AlphaCard::Account.password = 'password'
      #
      attr_accessor :username, :password

      ##
      # Setups demo Alpha Card credentials
      def use_demo_credentials!
        self.username = 'demo'
        self.password = 'password'
      end

      ##
      # Checks credentials not to be nil or empty string
      #
      # @param credentials [Hash] hash with :username and :password keys
      #
      # @return [Bool] true if credentials present, false in other cases
      #
      def valid_credentials?(credentials)
        !credentials[:username].to_s.empty? && !credentials[:password].to_s.empty?
      end

      ##
      # Returns hash with Alpha Card credentials
      #
      # @return [Hash] credentials
      #
      # @example
      #   AlphaCard::Account.username = 'john.doe'
      #   AlphaCard::Account.password = '123qwe!s'
      #
      #   AlphaCard::Account.credentials
      #   #=> { username: "john.doe", password: "123qwe!s" }
      #
      def credentials
        { username: username, password: password }
      end
    end
  end
end
