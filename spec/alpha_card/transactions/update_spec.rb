require 'spec_helper'

describe AlphaCard::Update do
  context 'with invalid attributes' do
    let(:update) { AlphaCard::Update.new(transaction_id: 'Some ID') }

    it 'response with error' do
      expect { update.process }.to raise_error(AlphaCard::AlphaCardError)
    end
  end

  context 'with valid attributes' do
    let(:update) { AlphaCard::Update.new(transaction_id: 'Some ID', po_number: 'PO1', shipping: 'Test') }

    it 'has valid request params' do
      expected_params = {
        transactionid: 'Some ID',
        type: 'update',
        ponumber: 'PO1',
        shipping: 'Test'
      }

      expect(update.attributes_for_request).to eq(expected_params)
    end
  end

  context 'with blank attributes' do
    let(:update) { AlphaCard::Update.new }

    it 'raises an InvalidObject error' do
      expect { update.create }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
