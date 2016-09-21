require 'spec_helper'

describe AlphaCard::Capture do
  let(:account) { AlphaCard::Account.new('demo', 'password') }

  context 'with invalid attributes' do
    let(:capture) { AlphaCard::Capture.new(transaction_id: 'Some ID', amount: '10.05') }

    it 'response with error' do
      expect { capture.create(account) }.to raise_error(AlphaCard::AlphaCardError)
    end
  end

  context 'with valid attributes' do
    let(:capture) { AlphaCard::Capture.new(transaction_id: 'Some ID', amount: '10.05', order_id: '1', shipping_carrier: '2') }

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
  end

  context 'with blank attributes' do
    it 'raises an InvalidObject error' do
      expect { AlphaCard::Refund.new.create(account) }.to raise_error(AlphaCard::InvalidObjectError)
      expect { AlphaCard::Refund.new(amount: '1.05').create(account) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
