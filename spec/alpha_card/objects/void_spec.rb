require 'spec_helper'

describe AlphaCard::Void do
  let(:account) { AlphaCard::Account.new('demo', 'password') }

  context 'with invalid attributes' do
    let(:void) { AlphaCard::Void.new(transactionid: 'Some ID') }

    it 'should response with error' do
      expect { void.create(account) }.to raise_error(AlphaCard::AlphaCardError)
    end
  end

  context 'with valid attributes' do
    let(:void) { AlphaCard::Void.new(transactionid: 'Some ID') }

    it 'should have valid request params' do
      expect(void.type).to eq('void')
    end
  end

  context 'with blank attributes' do
    let(:void) { AlphaCard::Void.new }

    it 'should raise an InvalidObject error' do
      expect { void.create(account) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
