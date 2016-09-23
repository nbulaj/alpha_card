require 'spec_helper'

describe AlphaCard::Auth do
  let(:order) { AlphaCard::Order.new(id: '1', description: 'Test') }
  let(:card_exp) { "#{'%02d' % Time.now.month}/#{Time.now.year.next}" }
  let(:auth) { AlphaCard::Auth.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

  context 'with invalid attributes' do
    let(:response) { described_class.new(card_expiration_date: '1', card_number: '1', amount: '1').create(order) }

    it 'response with error' do
      expect(response.error?).to be_truthy
      expect(response.message).to eq('Transaction was rejected by gateway')
    end
  end

  context 'with valid attributes' do
    it 'has valid request params' do
      expected_params = {
        ccexp: '09/2017',
        ccnumber: '4111111111111111',
        amount: '5.00',
        payment: 'creditcard',
        type: 'auth'
      }

      expect(auth.attributes_for_request).to eq(expected_params)
    end

    it 'processed successfully' do
      response = auth.create(order)
      expect(response.success?).to be_truthy
      expect(response.text).to eq('SUCCESS')
    end
  end

  context 'with blank attributes' do
    it 'raises an InvalidObject error' do
      expect { AlphaCard::Auth.new.create(order) }.to raise_error(AlphaCard::InvalidObjectError)
      expect { AlphaCard::Auth.new(amount: '1.05').create(order) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
