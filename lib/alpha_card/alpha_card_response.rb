module AlphaCard
  ##
  # Implementation of Alpha Card Services response.
  # Contains all the data, that Alpha Card Gateway
  # returned for the request.
  class AlphaCardResponse
    attr_reader :data

    # Success response code
    APPROVED = '1'
    # Decline response code
    DECLINED = '2'
    # Error response code
    ERROR    = '3'

    def initialize(request_body)
      @data = AlphaCard::Utils.parse_query(request_body)
    end

    def text
      @data['responsetext']
    end

    def transaction_id
      @data['transactionid']
    end

    def code
      @data['response_code']
    end

    def success?
      @data['response'] == APPROVED
    end

    def declined?
      @data['response'] == DECLINED
    end

    def error?
      @data['response'] == ERROR
    end
  end
end