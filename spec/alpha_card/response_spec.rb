require 'spec_helper'

describe AlphaCard::AlphaCardResponse do
  let(:successful_response_mock) do
    'authcode=083319&avsresponse=&cvvresponse=M&orderid=1&response=1&response_code=100&responsetext=AP&transactionid=2303767426&type=sale'
  end

  let(:declined_response_mock) do
    'authcode=&avsresponse=&cvvresponse=&orderid=1&response=2&response_code=220&responsetext=INVLD+ACCT&transactionid=2302720045&type=sale'
  end

  let(:error_response_mock) do
    'authcode=&avsresponse=&cvvresponse=&orderid=1&response=3&response_code=220&responsetext=ERROR&transactionid=2302620041&type=sale'
  end

  context 'successful request' do
    let(:response) { AlphaCard::AlphaCardResponse.new(successful_response_mock) }

    it 'success? = true' do
      expect(response.success?).to be_truthy
    end

    it 'returns response code' do
      expect(response.code).to eq('100')
    end

    it 'returns transaction id' do
      expect(response.transaction_id).to eq('2303767426')
    end
  end

  context 'declined request' do
    let(:response) { AlphaCard::AlphaCardResponse.new(declined_response_mock) }

    it 'declined? = true' do
      expect(response.declined?).to be_truthy
    end

    it 'returns responce code' do
      expect(response.code).to eq('220')
    end

    it 'returns transaction id' do
      expect(response.transaction_id).to eq('2302720045')
    end
  end

  context 'error request' do
    let(:response) { AlphaCard::AlphaCardResponse.new(error_response_mock) }

    it 'error? = true' do
      expect(response.error?).to be_truthy
    end

    it 'returns responce code' do
      expect(response.code).to eq('220')
    end

    it 'returns transaction id' do
      expect(response.transaction_id).to eq('2302620041')
    end
  end
end
