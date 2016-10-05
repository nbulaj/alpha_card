require 'spec_helper'

describe AlphaCard::Refund do
  context 'with invalid attributes' do
    let(:refund) { AlphaCard::Refund.new(transaction_id: 'Some ID', amount: '10.05') }
    let(:response) { refund.process }

    it 'response with error' do
      expect(response.error?).to be_truthy
      expect(response.message).to eq('Transaction was rejected by gateway')
    end
  end

  context 'with valid attributes' do
    let(:refund) { AlphaCard::Refund.new(transaction_id: 'Some ID', amount: '10.05') }

    it 'has valid request params' do
      expected_params = {
        transactionid: 'Some ID',
        type: 'refund',
        amount: '10.05'
      }

      expect(refund.attributes_for_request).to eq(expected_params)
    end
  end

  context 'with blank attributes' do
    let(:refund) { AlphaCard::Refund.new }

    it 'raises an InvalidObject error' do
      expect { refund.process }.to raise_error(AlphaCard::ValidationError)
    end
  end
end
