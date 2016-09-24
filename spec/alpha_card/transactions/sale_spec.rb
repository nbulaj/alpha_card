require 'spec_helper'

describe AlphaCard::Sale do
  let(:billing) { AlphaCard::Billing.new(email: 'test@example.com', address_1: 'N', address_2: 'Y') }
  let(:shipping) { AlphaCard::Shipping.new(first_name: 'John', last_name: 'Doe', address_1: '22 N str.') }
  let(:order) { AlphaCard::Order.new(id: '1', description: 'Test', billing: billing, shipping: shipping) }
  let(:card_exp) { "#{'%02d' % Time.now.month}/#{Time.now.year.next}" }

  context 'with valid attributes' do
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

    it 'has valid request params' do
      expected_params = {
        ccexp: '09/2017',
        ccnumber: '4111111111111111',
        amount: '5.00',
        payment: 'creditcard',
        type: 'sale',
        email: 'test@example.com',
        address1: 'N',
        address2: 'Y',
        orderid: '1',
        orderdescription: 'Test',
        shipping_address_1: '22 N str.',
        shipping_first_name: 'John',
        shipping_last_name: 'Doe'
      }

      expect(sale.send(:params_for_sale, order)).to eq(expected_params)
    end

    it 'successfully creates the sale' do
      expect(sale.create(order)).to be_truthy
    end
  end

  context 'with invalid Card number' do
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, card_number: 'Invalid', amount: '5.00') }
    let(:response) { sale.process(order) }

    it 'returns an error' do
      expect(response.error?).to be_truthy
      expect(response.text).to include('Card number must contain only digits')
    end
  end

  context 'with invalid amount' do
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '0.00') }
    let(:response) { sale.process(order) }

    it 'returns an error' do
      expect(response.error?).to be_truthy
      expect(response.text).to include('Invalid amount')
    end
  end

  context 'with invalid Card expiration date' do
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: 'Invalid', card_number: '4111111111111111', amount: '5.00') }
    let(:response) { sale.process(order) }

    it 'returns an error' do
      expect(response.error?).to be_truthy
      expect(response.text).to include('Card expiration should be in the format')
    end
  end

  context 'with invalid Card CVV' do
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, cvv: 'Invalid', card_number: '4111111111111111', amount: '5.00') }
    let(:response) { sale.process(order) }

    it 'returns an error' do
      expect(response.error?).to be_truthy
      expect(response.text).to include('CVV must be')
    end
  end

  context 'without attributes' do
    let(:sale) { AlphaCard::Sale.new }

    it 'raises an InvalidObjectError exception' do
      expect { sale.create(order) }.to raise_error(AlphaCard::InvalidObjectError)
    end
  end

  context 'with invalid account credentials' do
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }
    let(:response) { sale.process(order, username: 'demo', password: 'Invalid password') }

    it 'returns an error' do
      expect(response.error?).to be_truthy
      expect(response.text).to include('Authentication Failed')
    end
  end

  context 'with blank account credentials' do
    let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

    it 'raises an ArgumentError' do
      expect { sale.process(order, username: nil, password: '') }.to raise_error(ArgumentError) do |e|
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
      let(:sale) { AlphaCard::Sale.new(card_expiration_date: card_exp, card_number: '4111111111111111', amount: '5.00') }

      it 'handles an error' do
        AlphaCard.api_base = 'https://not-existing.com'
        expect { sale.create(order) }.to raise_error(AlphaCard::APIConnectionError)

        AlphaCard.api_base = 'https://secure.alphacardgateway.com/api/transact.php'
      end
    end
  end
end
