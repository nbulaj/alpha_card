require 'curb'
require 'yaml'
require 'virtus'
require 'rack'

require 'alpha_card/object'

require 'alpha_card/alpha_card_response'
require 'alpha_card/alpha_card_error'
require 'alpha_card/alpha_card_object'

require 'alpha_card/account'
require 'alpha_card/billing'
require 'alpha_card/order'
require 'alpha_card/sale'
require 'alpha_card/shipping'

module AlphaCard
  @api_base = 'https://secure.alphacardgateway.com/api/transact.php'

  CREDIT_CARD_CODES = YAML.load_file(File.expand_path('../alpha_card/data/codes.yml',  __FILE__)) unless defined? CREDIT_CARD_CODES

  class << self
    attr_accessor :api_base
  end

  def self.request(params, account)
    unless account.filled?
      raise AlphaCardError.new('You must set credentials to create the sale!')
    end

    auth_params = account.to_query

    curl = Curl::Easy.new(@api_base)
    curl.connect_timeout = 15
    curl.timeout = 15
    curl.header_in_body = false
    curl.ssl_verify_peer = false
    curl.post_body = [auth_params, params].join('&')
    curl.perform

    response = AlphaCardResponse.new(curl.body_str)
    handle_errors(response)

    response
  end

  private

  def self.handle_errors(response)
    code = response.text
    raise AlphaCardError.new(CREDIT_CARD_CODES[code] || code) unless response.success?
  end
end

