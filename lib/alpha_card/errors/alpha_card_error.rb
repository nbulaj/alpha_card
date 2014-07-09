module AlphaCard
  ##
  # Common class for Alpha Card Gateway errors and exceptions.
  class AlphaCardError < StandardError
    attr_reader :response
    attr_reader :message

    ##
    # <code>AlphaCard::AlphaCardError</code> constructor.
    #
    # @param [String] error message
    # @param [AlphaCard::AlphaCardResponse] AlphaCard Gateway response
    #
    # @example
    #   AlphaCard::AlphaCardError.new
    #
    #   #=> #<AlphaCard::AlphaCardError: AlphaCard::AlphaCardError>
    def initialize(message = nil, response = nil)
      @message = message
      @response = response
    end
  end
end
