require 'spec_helper'

describe AlphaCard::Account do
  let(:valid_account) { AlphaCard::Account.new('demo', 'password') }
  let(:invalid_account) { AlphaCard::Account.new('', '') }

  describe '#filled?' do
    context 'with filled credentials' do
      it 'returns true' do
        expect(valid_account.filled?).to be_truthy
      end
    end

    context 'with blank credentials' do
      it 'returns false' do
        expect(invalid_account.filled?).to be_falsey
      end
    end
  end
end
