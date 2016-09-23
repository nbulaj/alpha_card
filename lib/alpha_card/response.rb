module AlphaCard
  ##
  # Implementation of Alpha Card Services response.
  # Contains all the data, that Alpha Card Gateway
  # returned for the request.
  class Response
    # Alpha Card Gateway response as a <code>Hash</code>.
    # @attr_reader [Hash] data
    attr_reader :data

    # Success response code
    APPROVED = '1'.freeze
    # Decline response code
    DECLINED = '2'.freeze
    # Error response code
    ERROR    = '3'.freeze

    # Messages for CVV response codes
    CVV_RESPONSES = YAML.load_file(File.expand_path('../data/cvv_responses.yml', __FILE__)).freeze

    # Messages for AVS response codes
    AVS_RESPONSES = YAML.load_file(File.expand_path('../data/avs_responses.yml', __FILE__)).freeze

    # AlphaCard response messages
    RESPONSE_MESSAGES = YAML.load_file(File.expand_path('../data/response_messages.yml', __FILE__)).freeze

    ##
    # Alpha Card Response constructor.
    #
    # @param [String] response_body
    #   Alpha Card Gateway response body text
    #
    # @return [Response] Alpha Card Response object
    #
    # @example
    #   AlphaCard::Response.new('response=1&responsetext=Test')
    #
    #   #=> #<AlphaCard::Response:0x00000003f2b568 @data={"response"=>"1", "responsetext"=>"Test"}>
    def initialize(response_body)
      @data = Rack::Utils.parse_query(response_body)
    end

    ##
    # Textual response of the Alpha Card Gateway.
    #
    # @return [String] text of the response
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response=1&responsetext=Test")
    #   response.text
    #
    #   #=> 'Test'
    def text
      @data['responsetext']
    end

    ##
    # Response message by response code.
    #
    # @return [String] response message
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response_code=>300")
    #   response.message
    #
    #   #=> 'Transaction was rejected by gateway'
    def message
      RESPONSE_MESSAGES[code]
    end

    ##
    # Payment gateway transaction ID.
    #
    # @return [String] transaction ID
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response=1&transactionid=123")
    #   response.transaction_id
    #
    #   #=> '123'
    def transaction_id
      @data['transactionid']
    end

    ##
    # The original order id passed in the transaction request.
    #
    # @return [String] Order ID
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response=1&orderid=123")
    #   response.order_id
    #
    #   #=> '123'
    def order_id
      @data['orderid']
    end

    ##
    # Numeric mapping of processor responses.
    #
    # @return [String] code of the response
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response=1&response_code=100")
    #   response.code
    #
    #   #=> '100'
    def code
      @data['response_code']
    end

    ##
    # Transaction authorization code.
    #
    # @return [String] auth code
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response=1&authcode=083319")
    #   response.code
    #
    #   #=> '083319'
    def auth_code
      @data['authcode']
    end

    ##
    # Indicate the state of the request to the
    # Alpha Card Gateway. Returns <i>true</i> if
    # request was <i>approved</i>.
    #
    # @return [Bool] true if request if successful
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response=1")
    #   response.success?
    #
    #   #=> true
    def success?
      @data['response'] == APPROVED
    end

    ##
    # Indicate the state of the request to the
    # Alpha Card Gateway. Returns <i>true</i> if
    # request was <i>declined</i>.
    #
    # @return [Bool] true if request was declined
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response=2")
    #   response.declined?
    #
    #   #=> true
    def declined?
      @data['response'] == DECLINED
    end

    ##
    # Indicate the state of the request to the
    # Alpha Card Gateway. Returns <i>true</i> if
    # request has some <i>errors</i>.
    #
    # @return [Bool] true if request has some errors
    #
    # @example
    #
    #   response = AlphaCardResponse.new("response=3")
    #   response.error?
    #
    #   #=> true
    def error?
      @data['response'] == ERROR
    end

    ##
    # CVV response message.
    #
    # @return [String] CVV response message
    #
    # @example
    #
    #   response = AlphaCardResponse.new("cvvresponse=M")
    #   response.cvv_response
    #
    #   #=> 'CVV2/CVC2 match'
    def cvv_response
      CVV_RESPONSES[@data['cvvresponse']]
    end

    ##
    # AVS response message.
    #
    # @return [String] AVS response message
    #
    # @example
    #
    #   response = AlphaCardResponse.new("avsresponse=A")
    #   response.avs_response
    #
    #   #=> 'Address match only'
    def avs_response
      AVS_RESPONSES[@data['avsresponse']]
    end
  end
end
