require 'spec_helper'

describe AlphaCard::Credit do
  let(:order) { AlphaCard::Order.new(id: '1', description: 'Test') }
  let(:card_exp) { "#{'%02d' % Time.now.month}/#{Time.now.year.next}" }

  context 'with valid attributes' do
    let(:credit) { AlphaCard::Credit.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

    it 'has valid request params' do
      expected_params = {
        ccexp: card_exp,
        ccnumber: '4111111111111111',
        amount: '5.00',
        payment: 'creditcard',
        orderid: '1',
        orderdescription: 'Test',
        type: 'credit',
      }

      expect(credit.send(:params_for_sale, order)).to eq(expected_params)
    end

    it 'successfully creates the credit' do
      response = credit.create(order)
      expect(response.success?).to be_truthy
    end
  end

  context 'with invalid amount' do
    let(:credit) { AlphaCard::Credit.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '0.00') }
    let(:response) { credit.process(order) }

    it 'returns an error' do
      expect(response.error?).to be_truthy
      expect(response.text).to include('Invalid amount')
    end
  end

  context 'without attributes' do
    let(:credit) { AlphaCard::Credit.new }

    it 'raises an InvalidObjectError exception' do
      expect { credit.create(order) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end

  context 'with invalid account credentials' do
    let(:credit) { AlphaCard::Credit.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }
    let(:response) { credit.process(order, username: 'demo', password: 'Invalid password') }

    it 'returns an error' do
      expect(response.error?).to be_truthy
      expect(response.text).to include('Authentication Failed')
    end
  end

  context 'with blank account credentials' do
    let(:credit) { AlphaCard::Credit.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

    it 'raises an ArgumentError' do
      expect { credit.process(order, username: nil, password: '') }.to raise_error(ArgumentError) do |e|
        expect(e.message).to include('You must pass a Hash with Account credentials!')
      end
    end
  end

  context 'with connection errors' do
    let(:timeout_error) { Timeout::Error.new }
    let(:socket_error) { SocketError.new }
    let(:unclassified_error) { StandardError.new('Some error') }

    it 'raises an APIConnectionError if Timeout Error' do
      expect { AlphaCard.handle_connection_errors(timeout_error) }.to raise_error(AlphaCard::APIConnectionError) do |e|
        expect(e.message).to include('Could not connect to Alpha Card Gateway')
      end
    end

    it 'raises an APIConnectionError if Socket Error' do
      expect { AlphaCard.handle_connection_errors(socket_error) }.to raise_error(AlphaCard::APIConnectionError) do |e|
        expect(e.message).to include('Unexpected error communicating when trying to connect to Alpha Card Gateway')
      end
    end

    it 'raises an APIConnectionError if Unclassified Error' do
      expect { AlphaCard.handle_connection_errors(unclassified_error) }.to raise_error(AlphaCard::APIConnectionError) do |e|
        expect(e.message).to include('Unexpected error communicating with Alpha Card Gateway')
      end
    end

    context 'with request exception' do
      let(:credit) { AlphaCard::Credit.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

      it 'handles an error' do
        AlphaCard.api_base = 'https://not-existing.com'
        expect { credit.create(order) }.to raise_error(AlphaCard::APIConnectionError)

        AlphaCard.api_base = 'https://secure.alphacardgateway.com/api/transact.php'
      end
    end
  end
end
