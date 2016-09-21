# encoding:utf-8
require 'yaml'
require 'virtus'
require 'net/http'
require 'uri'
require 'rack/utils'

# Version
require 'alpha_card/version'

require 'alpha_card/alpha_card_object'
require 'alpha_card/alpha_card_response'

# Errors
require 'alpha_card/errors/alpha_card_error'
require 'alpha_card/errors/api_connection_error'
require 'alpha_card/errors/invalid_object_error'

# Alpha Card Resources
require 'alpha_card/objects/account'
require 'alpha_card/objects/billing'
require 'alpha_card/objects/capture'
require 'alpha_card/objects/shipping'
require 'alpha_card/objects/order'
require 'alpha_card/objects/void'
require 'alpha_card/objects/refund'
require 'alpha_card/objects/sale'
require 'alpha_card/objects/update'

##
# AlphaCard is a library for processing payments with Alpha Card Services, Inc.
module AlphaCard
  ##
  # Alpha Card Gateway DirectPost API URL
  @api_base = 'https://secure.alphacardgateway.com/api/transact.php'

  ##
  # Global Payment Systems (NDC) Credit Card Authorization Codes
  #
  # @see http://floristwiki.ftdi.com/images/c/ce/Appendix_A_-_Credit_Card_Authorization_Codes.pdf Credit Card Authorization Codes
  CREDIT_CARD_CODES = YAML.load_file(File.expand_path('../alpha_card/data/credit_card_codes.yml', __FILE__))

  class << self
    # @return [String] Alpha Card Gateway DirectPost API URL.
    attr_accessor :api_base

    ##
    # Send the POST request to the AlphaCard Gateway from the
    # specified account. Request must contains params - Alpha Card
    # transaction variables.
    #
    # @param [Hash] params
    #   Alpha Card transaction variables.
    # @param [AlphaCard::Account] account
    #   An <code>AlphaCard::Account</code> credentials object.
    #
    # @return [AlphaCard::AlphaCardResponse]
    #   Response from Alpha Card Gateway.
    #
    # @raise [AlphaCard::AlphaCardError]
    #   AlphaCardError Exception if request failed.
    #
    # @example
    #   account = AlphaCard::Account.new('demo', 'password')
    #   response = AlphaCard.request(
    #     account,
    #     {
    #       cexp: '0720',
    #       ccnumber: '4111111111111111',
    #       amount: '10.00'
    #     }
    #   )
    #
    #   #=> #<AlphaCard::AlphaCardResponse:0x1a0fda8 @data={"response"=>"1",
    #       "responsetext"=>"SUCCESS", "authcode"=>"123", "transactionid"=>"123",
    #       "avsresponse"=>"", "cvvresponse"=>"N", "orderid"=>"", "type"=>"",
    #       "response_code"=>"100"}>
    #
    #   account = AlphaCard::Account.new('demo', 'password')
    #   response = AlphaCard.request(
    #     account,
    #     {
    #       cexp: '0720',
    #       ccnumber: '123',
    #       amount: '10.00'
    #     }
    #   )
    #
    #   #=> AlphaCard::AlphaCardError: AlphaCard::AlphaCardError
    def request(account, params = {})
      raise AlphaCardError, 'You must set credentials to create the sale!' unless account.filled?

      begin
        response = http_post_request(@api_base, params.merge(account.attributes))
      rescue => e
        handle_connection_errors(e)
      end

      alpha_card_response = AlphaCardResponse.new(response.body)
      handle_alpha_card_errors(alpha_card_response)

      alpha_card_response
    end

    ##
    # Raises an exception if Alpha Card Gateway return an error or
    # decline code for the request. Message is taken from the Global
    # Payment Systems Credit Card Authorization Codes (codes.yml).
    # If code wasn't found in <code>CREDIT_CARD_CODES</code>, then
    # message = Alpha Card response text.
    #
    # @param [AlphaCard::AlphaCardResponse] response
    #   Alpha Card Response object.
    #
    # @raise [AlphaCard::AlphaCardError]
    #   AlphaCardError Exception if request failed.
    #
    # @return [String]
    #   Alpha Card Services response text.
    def handle_alpha_card_errors(response)
      code = response.text
      raise AlphaCardError.new(CREDIT_CARD_CODES[code] || code, response) unless response.success?
    end

    ##
    # Raises an exception if a network error occurs. It
    # could be request timeout, socket error or anything else.
    #
    # @param [StandardError]
    #   Exception object.
    #
    # @raise [AlphaCard::AlphaCardError]
    #   AlphaCardError Exception.
    def handle_connection_errors(error)
      case error
      when Timeout::Error, Errno::EINVAL, Errno::ECONNRESET
        message = "Could not connect to Alpha Card Gateway (#{@api_base}). " \
            'Please check your internet connection and try again. ' \
            'If this problem persists, you should check Alpha Card services status.'

      when SocketError
        message = 'Unexpected error communicating when trying to connect to Alpha Card Gateway. ' \
            'You may be seeing this message because your DNS is not working.'

      else
        message = 'Unexpected error communicating with Alpha Card Gateway.'
      end

      fail APIConnectionError, "#{message}\n\n(Network error: #{error.message})"
    end

    ##
    # Send secure HTTP(S) request with params
    # to requested URL.
    #
    # @param [String] url
    #   URL
    # @param [Hash] params
    #   Hash of params for the request
    #
    # @return [HTTPResponse]
    #   Response of the request as HTTPResponse object
    def http_post_request(url, params)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(params)

      http.request(request)
    end
  end
end
