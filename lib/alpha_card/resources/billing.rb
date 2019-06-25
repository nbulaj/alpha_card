# frozen_string_literal: true

# typed: true
module AlphaCard
  ##
  # Implementation of Alpha Card Services order billing information.
  # Contains all the billing information (customer name, email, email, etc).
  class Billing < Resource
    attribute :first_name, type: String
    attribute :last_name, type: String
    attribute :email, type: String
    attribute :phone, type: String
    attribute :company, type: String
    attribute :address_1, type: String
    attribute :address_2, type: String
    attribute :city, type: String
    attribute :state, type: String, format: /\A[A-Za-z]{2}\z/.freeze
    attribute :zip, type: String
    attribute :country, type: String, format: /\A[A-Za-z]{2}\z/.freeze
    attribute :fax, type: String
    attribute :website, type: String

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      first_name: :firstname,
      last_name: :lastname,
      address_1: :address1,
      address_2: :address2,
    }.freeze
  end
end
