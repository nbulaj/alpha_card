require 'spec_helper'

describe AlphaCard::Update do
  let(:account) { AlphaCard::Account.new('demo', 'password') }

  context 'with invalid attributes' do
    let(:update) { AlphaCard::Update.new(transactionid: 'Some ID') }

    it 'should response with error' do
      expect { update.create(account) }.to raise_error(AlphaCard::AlphaCardError)
    end
  end

  context 'with valid attributes' do
    let(:update) { AlphaCard::Update.new(transactionid: 'Some ID') }

    it 'should have valid request params' do
      expect(update.type).to eq('void')
    end
  end

  context 'with blank attributes' do
    let(:update) { AlphaCard::Update.new }

    it 'should raise an InvalidObject error' do
      expect { update.create(account) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end
end
