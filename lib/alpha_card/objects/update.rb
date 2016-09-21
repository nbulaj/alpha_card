module AlphaCard
  ##
  # Implementation of Alpha Card Services Update transaction.
  # Transaction updates can be used to update previous transactions
  # with specific order information, such as a tracking number
  # and shipping carrier.
  class Update < Void
    # Total shipping amount.
    # Format: x.xx
    attribute :shipping, String
    attribute :shipping_postal, String
    attribute :ship_from_postal, String
    attribute :shipping_country, String
    # Values: 'ups', 'fedex', 'dhl', or 'usps'
    attribute :shipping_carrier, String
    # Format: YYYYMMDD
    attribute :shipping_date, String
    attribute :order_description, String
    attribute :order_date, String
    # Values: 'true' or 'false'
    attribute :customer_receipt, String
    attribute :po_number, String
    attribute :summary_commodity_code, String
    # Format: x.xx
    attribute :duty_amount, String
    # Format: x.xx
    attribute :discount_amount, String
    # Format: x.xx
    attribute :tax, String
    # Format: x.xx
    attribute :national_tax_amount, String
    # Format: x.xx
    attribute :alternate_tax_amount, String
    attribute :alternate_tax_id, String
    attribute :vat_tax_amount, String
    attribute :vat_tax_rate, String
    attribute :vat_invoice_reference_number, String
    attribute :customer_vat_registration, String
    attribute :merchant_vat_registration, String

    ##
    # Transaction type (default is 'update')
    #
    # @attribute [r] type
    attribute :type, String, default: 'update', writer: :private

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      transaction_id: :transactionid,
      po_number: :ponumber
    }.freeze
  end
end
