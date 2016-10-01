module AlphaCard
  ##
  # Implementation of Alpha Card Services Validate transaction.
  class Validate < Sale
    ##
    # Transaction type (default is 'validate')
    #
    # @attribute [r] type
    attribute :type, default: 'validate', writable: false

    # Validate transaction can't have an amount
    remove_attribute :amount

    def process(order, credentials = Account.credentials)
      abort_if_attributes_blank!(:card_expiration_date, :card_number)

      AlphaCard.request(params_for_sale(order), credentials)
    end
    # amount не нужен
    alias create process
  end
end
