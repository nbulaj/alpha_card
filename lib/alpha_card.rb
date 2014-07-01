# encoding:utf-8
require 'yaml'
require 'virtus'
require 'rest_client'

require 'alpha_card/utils'
require 'alpha_card/alpha_card_object'
require 'alpha_card/alpha_card_response'
require 'alpha_card/alpha_card_error'

require 'alpha_card/account'
require 'alpha_card/shipping'
require 'alpha_card/billing'
require 'alpha_card/order'
require 'alpha_card/sale'

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
  CREDIT_CARD_CODES = YAML.load_file(File.expand_path('../alpha_card/data/codes.yml', __FILE__)) unless defined? CREDIT_CARD_CODES

  class << self
	# @return [String] Alpha Card Gateway DirectPost API URL.
    attr_accessor :api_base
  end

  ##
  # Send the POST request to the AlphaCard Gateway from the
  # specified account. Request must contains params - Alpha Card
  # transcation variables.
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
  #     {
  #       cexp: '0720',
  #       ccnumber: '4111111111111111',
  #       amount: '10.00'
  #     },
  #     account
  #   )
  #
  #   #=> #<AlphaCard::AlphaCardResponse:0x1a0fda8 @data={"response"=>"1",
  #       "responsetext"=>"SUCCESS", "authcode"=>"123", "transactionid"=>"123",
  #       "avsresponse"=>"", "cvvresponse"=>"N", "orderid"=>"", "type"=>"",
  #       "response_code"=>"100"}>
  def self.request(params = {}, account)
    unless account.filled?
      raise AlphaCardError.new('You must set credentials to create the sale!')
    end

    begin
      response = RestClient.post(@api_base, params.merge(account.attributes))
    rescue => e
      handle_connection_errors(e)
    end

    alpha_card_response = AlphaCardResponse.new(response.to_str)
    handle_alpha_card_errors(alpha_card_response)

    alpha_card_response
  end

  private

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
  def self.handle_alpha_card_errors(response)
    code = response.text
    raise AlphaCardError.new(CREDIT_CARD_CODES[code] || code) unless response.success?
  end

  ##
  # Raises an exception if a network error occurs. It
  # could be request timeout, socket error or anything else.
  #
  # @param [Exception] e
  #   Exception object.
  #
  # @raise [AlphaCard::AlphaCardError]
  #   AlphaCardError Exception.
  def self.handle_connection_errors(e)
    case e
      when RestClient::ServerBrokeConnection, RestClient::RequestTimeout
        message = "Could not connect to Alpha Card Gateway (#{@api_base}). " +
            'Please check your internet connection and try again. ' +
            'If this problem persists, you should check Alpha Card services status.'

      when SocketError
        message = 'Unexpected error communicating when trying to connect to Alpha Card Gateway. ' +
            'You may be seeing this message because your DNS is not working.'

      else
        message = 'Unexpected error communicating with Alpha Card Gateway.'
    end

    raise AlphaCardError.new(message + "\n\n(Network error: #{e.message})")
  end
end

