module AlphaCard
  ##
  # Implementation of Alpha Card Services Update transaction.
  # Transaction updates can be used to update previous transactions
  # with specific order information, such as a tracking number
  # and shipping carrier.
  #
  # @example
  #   update = AlphaCard::Update.new(card_expiration_date: '0117', card_number: '4111111111111111', amount: '1.00')
  #   update.process(order)
  #
  #   #=> #<AlphaCard::Response:0x1a0fda ...>
  #
  class Update < Void
    # Total shipping amount.
    # Format: x.xx
    attribute :shipping
    attribute :shipping_postal
    attribute :ship_from_postal
    attribute :shipping_country
    # Values: 'ups', 'fedex', 'dhl', or 'usps'
    attribute :shipping_carrier, values: %w(ups fedex dhl usps).freeze
    # Format: YYYYMMDD
    attribute :shipping_date, format: /\A[1-9]\d{3}((0[1-9])|(1[0-2]))((0[1-9])|((1|2)[0-9])|3[0-1])\z/.freeze
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
