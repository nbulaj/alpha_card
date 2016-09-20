require 'spec_helper'

describe AlphaCard::Refund do
  let(:account) { AlphaCard::Account.new('demo', 'password') }

  context 'with invalid attributes' do
    let(:refund) { AlphaCard::Refund.new(transactionid: 'Some ID', amount: '10.05') }

    it 'should response with error' do
      expect { refund.create(account) }.to raise_error(AlphaCard::AlphaCardError)
    end
  end

  context 'with valid attributes' do
    let(:refund) { AlphaCard::Refund.new(transactionid: 'Some ID', amount: '10.05') }

    it 'should have valid request params' do
      expect(refund.type).to eq('refund')
    end
  end

  context 'with blank attributes' do
    let(:refund) { AlphaCard::Refund.new }

    it 'should raise an InvalidObject error' do
      expect { refund.create(account) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
