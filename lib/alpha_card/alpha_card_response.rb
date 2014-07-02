module AlphaCard
  ##
  # Implementation of Alpha Card Services response.
  # Contains all the data, that Alpha Card Gateway
  # returned for the request.
  class AlphaCardResponse
    attr_reader :data

    # Success response code
    APPROVED = '1'
    # Decline response code
    DECLINED = '2'
    # Error response code
    ERROR    = '3'

    def initialize(request_body)
      @data = AlphaCard::Utils.parse_query(request_body)
    end

    ##
    # The text of the Alpha Card Gateway response.
    #
    # @return [String] text of the response
    def text
      @data['responsetext']
    end

    ##
    # The ID of the transaction. Can be used to process
    # refund operation.
    #
    # @return [String] transaction ID
    def transaction_id
      @data['transactionid']
    end

    ##
    # The code of the Alpha Card Gateway response.
    #
    # @return [String] code of the response
    def code
      @data['response_code']
    end

    ##
    # Indicate the state of the request to the
    # Alpha Card Gateway. Returns <i>true</i> if
    # response was <i>approved</i>.
    #
    # @return [Bool] true if request if successful
    #
    # @example
    #
    #   r = AlphaCardResponse.new("response=1")
    #   r.success?
    #   #=> true
    def success?
      @data['response'] == APPROVED
    end

    ##
    # Indicate the state of the request to the
    # Alpha Card Gateway. Returns <i>true</i> if
    # response was <i>declined</i>.
    #
    # @return [Bool] true if request was declined
    #
    # @example
    #
    #   r = AlphaCardResponse.new("response=2")
    #   r.declined?
    #   #=> true
    def declined?
      @data['response'] == DECLINED
    end

    ##
    # Indicate the state of the request to the
    # Alpha Card Gateway. Returns <i>true</i> if
    # response has some <i>errors</i>.
    #
    # @return [Bool] true if request has some errors
    #
    # @example
    #
    #   r = AlphaCardResponse.new("response=3")
    #   r.error?
    #   #=> true
    def error?
      @data['response'] == ERROR
    end
  end
end