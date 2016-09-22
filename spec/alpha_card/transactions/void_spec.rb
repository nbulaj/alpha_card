require 'spec_helper'

describe AlphaCard::Void do
  let(:account) { AlphaCard::Account.new('demo', 'password') }

  context 'with invalid attributes' do
    let(:void) { AlphaCard::Void.new(transaction_id: 'Some ID') }

    it 'response with error' do
      expect { void.create(account) }.to raise_error(AlphaCard::AlphaCardError)
    end
  end

  context 'with valid attributes' do
    let(:void) { AlphaCard::Void.new(transaction_id: '2303767426') }

    let(:order) { AlphaCard::Order.new(id: '1', description: 'Test') }
    let(:card_exp) { "#{'%02d' % Time.now.month}/#{Time.now.year.next}" }
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

    it 'has valid request params' do
      expected_params = {
        transactionid: '2303767426',
        type: 'void'
      }

      expect(void.attributes_for_request).to eq(expected_params)
    end

    it 'processed successfully' do
      success, response = sale.create(order, account)
      expect(success).to be_truthy
      expect(response.transaction_id).not_to be_nil

      success, response = AlphaCard::Void.new(transaction_id: response.transaction_id).create(account)
      expect(success).to be_truthy
      expect(response.text).to eq('Transaction Void Successful')
    end
  end

  context 'with blank attributes' do
    let(:void) { AlphaCard::Void.new }

    it 'raises an InvalidObject error' do
      expect { void.create(account) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
