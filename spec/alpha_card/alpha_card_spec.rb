require "spec_helper"

describe AlphaCard do
  # Shared objects
  let!(:account) { AlphaCard::Account.new('demo', 'password') }
  let!(:billing) { AlphaCard::Billing.new({email: 'test@example.com'}) }
  let!(:shipping) { AlphaCard::Shipping.new({address_1: '22 N str.'}) }
  let!(:order) { AlphaCard::Order.new({orderid: '1', billing: billing, shipping: shipping}) }
  let!(:card_exp) { "#{'%02d' % Time.now.month}/#{Time.now.year.next}" }

  #TODO: Create rest client mock to imitate requests, normal tests for error exceptions

  context 'With valid attributes' do
    let!(:sale) { AlphaCard::Sale.new({ccexp: card_exp, ccnumber: '4111111111111111', amount: '5.00'}) }

    it 'should successfully create the sale' do
      expect(sale.create(order, account)).to be_truthy
    end
  end

  context 'With invalid Card number' do
    let!(:sale) { AlphaCard::Sale.new({ccexp: card_exp, ccnumber: 'Invalid', amount: '5.00'}) }

    it 'should raise an AlphaCardError' do
      expect { sale.create(order, account) }.to raise_error(AlphaCard::AlphaCardError) do |e|
        expect(e.message).to include('Card number must contain only digits')
      end
    end
  end

  context 'With invalid amount' do
    let!(:sale) { AlphaCard::Sale.new({ccexp: card_exp, ccnumber: '4111111111111111', amount: '0.00'}) }

    it 'should raise an AlphaCardError' do
      expect { sale.create(order, account) }.to raise_error(AlphaCard::AlphaCardError) do |e|
        expect(e.message).to include('Invalid amount')
      end
    end
  end

  context 'With invalid Card expiration date' do
    let!(:sale) { AlphaCard::Sale.new({ccexp: 'Invalid', ccnumber: '4111111111111111', amount: '5.00'}) }

    it 'should raise an AlphaCardError' do
      expect { sale.create(order, account) }.to raise_error(AlphaCard::AlphaCardError) do |e|
        expect(e.message).to include('Card expiration should be in the format')
      end
    end
  end

  context 'With invalid Card CVV' do
    let!(:sale) { AlphaCard::Sale.new({ccexp: card_exp, cvv: 'Invalid', ccnumber: '4111111111111111', amount: '5.00'}) }

    it 'should raise an AlphaCardError' do
      expect { sale.create(order, account) }.to raise_error(AlphaCard::AlphaCardError) do |e|
        expect(e.message).to include('CVV must be')
      end
    end
  end

  context 'With invalid account credentials' do
    let!(:invalid_account) { AlphaCard::Account.new('demo', 'Invalid password') }
    let!(:sale) { AlphaCard::Sale.new({ccexp: card_exp, ccnumber: '4111111111111111', amount: '5.00'}) }

    it 'should raise an AlphaCardError' do
      expect { sale.create(order, invalid_account) }.to raise_error(AlphaCard::AlphaCardError) do |e|
        expect(e.message).to include('Authentication Failed')
      end
    end
  end

  context 'Without attributes' do
    let!(:sale) { AlphaCard::Sale.new({}) }

    it 'should raise an Exception' do
      expect { sale.create(order, account) }.to raise_exception
    end
  end

  context 'With blank account credentials' do
    let!(:blank_account) { AlphaCard::Account.new(nil, '') }
    let!(:sale) { AlphaCard::Sale.new({ccexp: card_exp, ccnumber: '4111111111111111', amount: '5.00'}) }

    it 'should raise an AlphaCardError' do
      expect { sale.create(order, blank_account) }.to raise_error(AlphaCard::AlphaCardError) do |e|
        expect(e.message).to include('You must set credentials to create the sale')
      end
    end
  end

  context 'With connection errors' do
    let!(:rest_client_error) { RestClient::RequestTimeout.new }
    let!(:socket_error) { SocketError.new }
    let!(:unclassified_error) { StandardError.new('Some error') }

    it 'should raise an APIConnectionError if Rest Client Error' do
      expect { AlphaCard.handle_connection_errors(rest_client_error) }.to raise_error(AlphaCard::APIConnectionError) do |e|
        expect(e.message).to include('Could not connect to Alpha Card Gateway')
      end
    end

    it 'should raise an APIConnectionError if Socket Error' do
      expect { AlphaCard.handle_connection_errors(socket_error) }.to raise_error(AlphaCard::APIConnectionError) do |e|
        expect(e.message).to include('Unexpected error communicating when trying to connect to Alpha Card Gateway')
      end
    end

    it 'should raise an APIConnectionError if Unclassified Error' do
      expect { AlphaCard.handle_connection_errors(unclassified_error) }.to raise_error(AlphaCard::APIConnectionError) do |e|
        expect(e.message).to include('Unexpected error communicating with Alpha Card Gateway')
      end
    end
  end
end