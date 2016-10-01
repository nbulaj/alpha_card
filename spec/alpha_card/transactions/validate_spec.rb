require 'spec_helper'

describe AlphaCard::Validate do
  let(:order) { AlphaCard::Order.new(id: '1', description: 'Test') }
  let(:card_exp) { "#{'%02d' % Time.now.month}/#{Time.now.year.next}" }

  context 'with valid attributes' do
    let(:validate) { AlphaCard::Validate.new(card_expiration_date: card_exp, card_number: '4111111111111111') }

    it 'has valid request params' do
      expected_params = {
        ccexp: card_exp,
        ccnumber: '4111111111111111',
        payment: 'creditcard',
        orderid: '1',
        orderdescription: 'Test',
        type: 'validate',
      }

      expect(validate.send(:params_for_sale, order)).to eq(expected_params)
    end

    it 'successfully processed' do
      response = validate.create(order)
      expect(response.success?).to be_truthy
    end
  end

  context 'with amount' do
    let(:validate) { described_class.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '1.22') }

    it 'must ignore it' do
      expect(validate.send(:params_for_sale, order)).not_to include(:amount)
    end
  end


  context 'without attributes' do
    let(:validate) { described_class.new }

    it 'raises an InvalidObjectError exception' do
      expect { validate.create(order) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end

  context 'with invalid account credentials' do
    let(:validate) { described_class.new(card_expiration_date: card_exp, card_number: '4111111111111111') }
    let(:response) { validate.process(order, username: 'demo', password: 'Invalid password') }

    it 'returns an error' do
      expect(response.error?).to be_truthy
      expect(response.text).to include('Authentication Failed')
    end
  end

  context 'with blank account credentials' do
    let(:validate) { described_class.new(card_expiration_date: card_exp, card_number: '4111111111111111') }

    it 'raises an ArgumentError' do
      expect { validate.process(order, username: nil, password: '') }.to raise_error(ArgumentError) do |e|
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
      let(:validate) { described_class.new(card_expiration_date: card_exp, card_number: '4111111111111111') }

      it 'handles an error' do
        AlphaCard.api_base = 'https://not-existing.com'
        expect { validate.create(order) }.to raise_error(AlphaCard::APIConnectionError)

        AlphaCard.api_base = 'https://secure.alphacardgateway.com/api/transact.php'
      end
    end
  end
end
