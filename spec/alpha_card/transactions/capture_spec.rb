require 'spec_helper'

describe AlphaCard::Capture do
  context 'with invalid attributes' do
    let(:capture) { AlphaCard::Capture.new(transaction_id: 'Some ID', amount: '10.05') }
    let(:response) { capture.process }

    it 'response with error' do
      expect(response.error?).to be_truthy
      expect(response.message).to eq('Transaction was rejected by gateway')
    end
  end

  context 'with valid attributes' do
    let(:capture) { AlphaCard::Capture.new(transaction_id: 'Some ID', amount: '10.05', order_id: '1', shipping_carrier: '2') }

    let(:order) { AlphaCard::Order.new(id: '1', description: 'Test') }
    let(:card_exp) { "#{'%02d' % Time.now.month}/#{Time.now.year.next}" }
    let(:auth) { AlphaCard::Auth.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

    it 'has valid request params' do
      expected_params = {
        transactionid: 'Some ID',
        type: 'capture',
        amount: '10.05',
        shipping_carrier: '2',
        orderid: '1'
      }

      expect(capture.attributes_for_request).to eq(expected_params)
    end

    it 'processed successfully' do
      response = auth.create(order)
      expect(response.success?).to be_truthy
      expect(response.transaction_id).not_to be_nil

      response = AlphaCard::Capture.new(transaction_id: response.transaction_id, amount: '2.00').create
      expect(response.success?).to be_truthy
      expect(response.text).to eq('SUCCESS')
    end
  end

  context 'with blank attributes' do
    it 'raises an InvalidObject error' do
      expect { AlphaCard::Refund.new.process }.to raise_error(AlphaCard::InvalidObjectError)
      expect { AlphaCard::Refund.new(amount: '1.05').process }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
