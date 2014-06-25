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
  CREDIT_CARD_CODES = YAML.load_file(File.expand_path('../alpha_card/data/codes.yml',  __FILE__)) unless defined? CREDIT_CARD_CODES

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

    response = RestClient.post(@api_base, params.merge(account.attributes))

    alpha_card_response = AlphaCardResponse.new(response.to_str)
    handle_errors(alpha_card_response)

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
  def self.handle_errors(response)
    code = response.text
    raise AlphaCardError.new(CREDIT_CARD_CODES[code] || code) unless response.success?
  end
end

