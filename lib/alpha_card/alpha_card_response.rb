module AlphaCard
  class AlphaCardResponse
    attr_reader :data

    APPROVED = '1'
    DECLINED = '2'
    ERROR    = '3'

    def initialize(request_body)
      @data = Rack::Utils.parse_nested_query(request_body)
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