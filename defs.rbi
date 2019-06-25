# typed: strong
module AlphaCard
  sig { returns(String) }
  def self.api_base(); end

  sig { params(value: String).returns(String) }
  def self.api_base=(value); end

  sig { params(params: Hash, credentials: Hash).returns(AlphaCard::Response) }
  def self.request(params = {}, credentials = Account.credentials); end

  sig { params(error: Exception).returns(T.noreturn) }
  def self.handle_connection_errors(error); end

  sig { params(url: String, params: Hash).returns(Net::HTTPResponse) }
  def self.http_post_request(url, params); end

  sig { returns(Gem::Version) }
  def self.gem_version(); end

  class Account
    sig { returns(String) }
    def self.username(); end

    sig { params(value: String).returns(String) }
    def self.username=(value); end

    sig { returns(String) }
    def self.password(); end

    sig { params(value: String).returns(String) }
    def self.password=(value); end

    sig { void }
    def self.use_demo_credentials!(); end

    sig { params(credentials: Hash).returns(T::Boolean) }
    def self.valid_credentials?(credentials); end

    sig { returns(Hash) }
    def self.credentials(); end
  end

  module VERSION
  end

  class Resource
    extend AlphaCard::Attribute

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Response
    sig { returns(Hash) }
    def data(); end

    sig { params(response_body: String).returns(Response) }
    def initialize(response_body); end

    sig { returns(T.nilable(String)) }
    def text(); end

    sig { returns(T.nilable(String)) }
    def message(); end

    sig { returns(T.nilable(String)) }
    def transaction_id(); end

    sig { returns(T.nilable(String)) }
    def order_id(); end

    sig { returns(T.nilable(String)) }
    def code(); end

    sig { returns(T.nilable(String)) }
    def auth_code(); end

    sig { returns(T.nilable(String)) }
    def credit_card_auth_message(); end

    sig { returns(T::Boolean) }
    def success?(); end

    sig { returns(T::Boolean) }
    def declined?(); end

    sig { returns(T::Boolean) }
    def error?(); end

    sig { returns(T.nilable(String)) }
    def cvv_response(); end

    sig { returns(T.nilable(String)) }
    def avs_response(); end
  end

  module Attribute
    sig { params(base: Class).void }
    def self.included(base); end

    module ClassMethods
      sig { returns(Hash) }
      def attributes_set(); end

      sig { params(name: T.any(Symbol, String), options: Hash).void }
      def attribute(name, options = {}); end

      sig { params(name: T.any(String, Symbol)).void }
      def remove_attribute(name); end

      sig { params(subclass: Class).void }
      def inherited(subclass); end

      sig { params(name: T.any(String, Symbol)).void }
      def define_reader(name); end

      sig { params(name: Symbol, options: Hash).void }
      def define_writer(name, options = {}); end

      sig { params(options: Hash).returns(Array) }
      def extract_values_from(options = {}); end

      sig { params(options: Hash).returns(Regexp) }
      def extract_format_from(options = {}); end

      sig { params(options: Hash).returns(T::Array[Class]) }
      def extract_types_from(options = {}); end
    end

    module InstanceMethods
      sig { params(attributes: Hash).void }
      def initialize(attributes = {}); end

      sig { returns(Hash) }
      def attributes(); end

      sig { params(name: T.any(String, Symbol)).returns(Object) }
      def [](name); end

      sig { returns(Array) }
      def required_attributes(); end

      sig { returns(T::Boolean) }
      def required_attributes?(); end

      sig { params(name: T.any(String, Symbol), value: Object).void }
      def set_attribute_safely(name, value); end

      sig { params(name: T.any(String, Symbol)).returns(T::Boolean) }
      def attribute_writable?(name); end

      sig { void }
      def set_attributes_defaults!(); end
    end
  end

  class Transaction < AlphaCard::Resource
    sig { params(credentials: Hash).returns(AlphaCard::Response) }
    def process(credentials = Account.credentials); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Order < AlphaCard::Resource
    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Billing < AlphaCard::Resource
    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Auth < AlphaCard::Sale
    sig { returns(String) }
    def type(); end

    sig { returns(String) }
    def payment(); end

    sig { params(order: AlphaCard::Order, credentials: Hash).returns(AlphaCard::Response) }
    def process(order, credentials = Account.credentials); end

    sig { params(order: AlphaCard::Order).returns(Hash) }
    def params_for_sale(order); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Sale < AlphaCard::Transaction
    sig { returns(String) }
    def payment(); end

    sig { returns(String) }
    def type(); end

    sig { params(order: AlphaCard::Order, credentials: Hash).returns(AlphaCard::Response) }
    def process(order, credentials = Account.credentials); end

    sig { params(order: AlphaCard::Order).returns(Hash) }
    def params_for_sale(order); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Void < AlphaCard::Transaction
    sig { returns(String) }
    def type(); end

    sig { params(credentials: Hash).returns(AlphaCard::Response) }
    def process(credentials = Account.credentials); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Shipping < AlphaCard::Resource
    sig { returns(Hash) }
    def filled_attributes(); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Credit < AlphaCard::Sale
    sig { returns(String) }
    def type(); end

    sig { returns(String) }
    def payment(); end

    sig { params(order: AlphaCard::Order, credentials: Hash).returns(AlphaCard::Response) }
    def process(order, credentials = Account.credentials); end

    sig { params(order: AlphaCard::Order).returns(Hash) }
    def params_for_sale(order); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Refund < AlphaCard::Void
    sig { returns(String) }
    def type(); end

    sig { params(credentials: Hash).returns(AlphaCard::Response) }
    def process(credentials = Account.credentials); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Update < AlphaCard::Void
    sig { returns(String) }
    def type(); end

    sig { params(credentials: Hash).returns(AlphaCard::Response) }
    def process(credentials = Account.credentials); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Capture < AlphaCard::Transaction
    sig { returns(String) }
    def type(); end

    sig { params(credentials: Hash).returns(AlphaCard::Response) }
    def process(credentials = Account.credentials); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class Validate < AlphaCard::Sale
    sig { returns(String) }
    def type(); end

    sig { returns(String) }
    def payment(); end

    sig { params(order: AlphaCard::Order, credentials: Hash).returns(AlphaCard::Response) }
    def process(order, credentials = Account.credentials); end

    sig { params(order: AlphaCard::Order).returns(Hash) }
    def params_for_sale(order); end

    sig { params(attrs: Hash).returns(Hash) }
    def attributes_for_request(attrs = filled_attributes); end

    sig { returns(Hash) }
    def filled_attributes(); end

    sig { void }
    def validate_required_attributes!(); end
  end

  class ValidationError < StandardError
  end

  class APIConnectionError < StandardError
  end

  class InvalidAttributeType < StandardError
    sig { params(value: Object, types: Array).returns(InvalidAttributeType) }
    def initialize(value, types); end
  end

  class InvalidAttributeValue < StandardError
    sig { params(value: Object, values: Array).returns(InvalidAttributeValue) }
    def initialize(value, values); end
  end

  class InvalidAttributeFormat < StandardError
    sig { params(value: Object, format: Regexp).returns(InvalidAttributeFormat) }
    def initialize(value, format); end
  end
end