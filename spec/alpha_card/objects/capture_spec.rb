require 'spec_helper'

describe AlphaCard::Capture do
  let(:account) { AlphaCard::Account.new('demo', 'password') }

  context 'with invalid attributes' do
    let(:capture) { AlphaCard::Capture.new(transactionid: 'Some ID', amount: '10.05') }

    it 'should response with error' do
      expect { capture.create(account) }.to raise_error(AlphaCard::AlphaCardError)
    end
  end

  context 'with valid attributes' do
    let(:capture) { AlphaCard::Capture.new(transactionid: 'Some ID', amount: '10.05') }

    it 'should have valid request params' do
      expect(capture.type).to eq('capture')
    end
  end

  context 'with blank attributes' do
    it 'should raise an InvalidObject error' do
      expect { AlphaCard::Refund.new.create(account) }.to raise_error(AlphaCard::InvalidObjectError)
      expect { AlphaCard::Refund.new(amount: '1.05').create(account) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
