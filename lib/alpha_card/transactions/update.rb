module AlphaCard
  ##
  # Implementation of Alpha Card Services Update transaction.
  # Transaction updates can be used to update previous transactions
  # with specific order information, such as a tracking number
  # and shipping carrier.
  class Update < Void
    # Total shipping amount.
    # Format: x.xx
    attribute :shipping
    attribute :shipping_postal
    attribute :ship_from_postal
    attribute :shipping_country
    # Values: 'ups', 'fedex', 'dhl', or 'usps'
    attribute :shipping_carrier
    # Format: YYYYMMDD
    attribute :shipping_date
    attribute :order_description
    attribute :order_date
    # Values: 'true' or 'false'
    attribute :customer_receipt
    attribute :po_number
    attribute :summary_commodity_code
    # Format: x.xx
    attribute :duty_amount
    # Format: x.xx
    attribute :discount_amount
    # Format: x.xx
    attribute :tax
    # Format: x.xx
    attribute :national_tax_amount
    # Format: x.xx
    attribute :alternate_tax_amount
    attribute :alternate_tax_id
    attribute :vat_tax_amount
    attribute :vat_tax_rate
    attribute :vat_invoice_reference_number
    attribute :customer_vat_registration
    attribute :merchant_vat_registration

    ##
    # Transaction type (default is 'update')
    #
    # @attribute [r] type
    attribute :type, default: 'update', writable: false

    ##
    # Original AlphaCard transaction variables names
    ORIGIN_TRANSACTION_VARIABLES = {
      transaction_id: :transactionid,
      po_number: :ponumber
    }.freeze
  end
end
