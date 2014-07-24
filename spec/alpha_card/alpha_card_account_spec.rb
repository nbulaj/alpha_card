require "spec_helper"

describe AlphaCard::Account do
  let!(:valid_account) { AlphaCard::Account.new('demo', 'password') }
  let!(:invalid_account) { AlphaCard::Account.new('', '') }

  context 'with valid credentials' do
    it 'should return true if credentials are filled' do
      expect(valid_account.filled?).to be_truthy
    end
  end

  context 'with invalid credentials' do
    it 'should return false if credentials are filled' do
      expect(invalid_account.filled?).to be_falsey
    end
  end
end
