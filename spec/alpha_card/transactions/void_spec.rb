require 'spec_helper'

describe AlphaCard::Void do
  context 'with invalid attributes' do
    let(:void) { AlphaCard::Void.new(transaction_id: 'Some ID') }
    let(:response) { void.create }

    it 'response with error' do
      expect(response.error?).to be_truthy
      expect(response.message).to eq('Transaction was rejected by gateway')
    end
  end

  context 'with valid attributes' do
    let(:void) { AlphaCard::Void.new(transaction_id: '2303767426') }

    let(:order) { AlphaCard::Order.new(id: '1', description: 'Test') }
    let(:card_exp) { (Time.now + 31104000).strftime('%m%y') }
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

    it 'has valid request params' do
      expected_params = {
        transactionid: '2303767426',
        type: 'void'
      }

      expect(void.attributes_for_request).to eq(expected_params)
    end

    it 'processed successfully' do
      response = sale.create(order)
      expect(response.success?).to be_truthy
      expect(response.transaction_id).not_to be_nil

      response = AlphaCard::Void.new(transaction_id: response.transaction_id).process
      expect(response.success?).to be_truthy
      expect(response.text).to eq('Transaction Void Successful')
    end
  end

  context 'with blank attributes' do
    let(:void) { AlphaCard::Void.new }

    it 'raises an InvalidObject error' do
      expect { void.create }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
