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
    let(:void) { AlphaCard::Void.new(transaction_id: 'Some ID') }

    it 'has valid request params' do
      expected_params = {
        transactionid: 'Some ID',
        type: 'void'
      }

      expect(void.attributes_for_request).to eq(expected_params)
    end
  end

  context 'with blank attributes' do
    let(:void) { AlphaCard::Void.new }

    it 'raises an InvalidObject error' do
      expect { void.create(account) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
