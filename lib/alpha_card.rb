require 'yaml'
require 'virtus'
require 'rack'
require 'rest_client'

require 'alpha_card/object'
require 'alpha_card/alpha_card_object'
require 'alpha_card/alpha_card_response'
require 'alpha_card/alpha_card_error'

require 'alpha_card/account'
require 'alpha_card/shipping'
require 'alpha_card/billing'
require 'alpha_card/order'
require 'alpha_card/sale'

module AlphaCard
  # DirectPost API URL
  @api_base = 'https://secure.alphacardgateway.com/api/transact.php'

  # Global Payment Systems (NDC) Credit Card Authorization Codes
  CREDIT_CARD_CODES = YAML.load_file(File.expand_path('../alpha_card/data/codes.yml', __FILE__)) unless defined? CREDIT_CARD_CODES

  class << self
    attr_accessor :api_base
  end

  # AlphaCard.request(params, account) -> AlphaCardResponse
  #
  # Do the POST request to the AlphaCard Gateway with <i>params</i>
  # from specified AlphaCard <i>account</i>.
  #
  #    account = AlphaCard::Account.new('user', 'pass')
  #    params = {amount: '10.00'}
  #    r = AlphaCard.request(params, account) #=> AlphaCardResponse
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

  # AlphaCard.handle_errors(response) -> Exception
  # AlphaCard.handle_errors(response) -> nil
  #
  # Raise an exception if AlphaCard Gateway return an error or decline
  # the request.
  #
  #    response = AlphaCard.request(params, account)
  #    handle_errors(response) #=> nil or Exception
  def self.handle_alpha_card_errors(response)
    code = response.text
    raise AlphaCardError.new(CREDIT_CARD_CODES[code] || code) unless response.success?
  end

  # AlphaCard.handle_connection_errors(exception) -> Exception
  #
  # Raise an exception if AlphaCard Gateway return some exception
  # due to connection problems or some other net errors.
  #
  #    response = RestClient.post(URL, {param: 'value'})
  #    handle_connection_errors(response) #=> Exception
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

