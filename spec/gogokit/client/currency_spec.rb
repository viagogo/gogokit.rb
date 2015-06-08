require 'rspec'
require 'spec_helper'

describe GogoKit::Client::Currency do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  let(:root) do
    self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/')
    currencies_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/ct')
    root = GogoKit::Root.new
    root.links = {
      'self' => self_link,
      'viagogo:currencies' => currencies_link
    }
    root
  end

  describe '#get_currency' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_currency 'BDS'
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request built from the self link of the root resource' do
      self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://apiroot.com')
      root = GogoKit::Root.new
      root.links = {'self' => self_link}
      expected_url = self_link.href + '/currencies/EX'
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_currency 'EX'

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_currency('BDS', expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::Currency} created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('currency.json'))
      currencies = client.get_currency 'BB'
      expect(currencies).to be_an_instance_of(GogoKit::Currency)
    end
  end

  describe '#get_currencies' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_currencies
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request to the viagogo:currencies rel on root resource' do
      expected_url = 'http://apiv2.com/currencies'
      currencies_link = Roar::Hypermedia::Hyperlink.new(href: expected_url)
      root = GogoKit::Root.new
      root.links = {'viagogo:currencies' => currencies_link}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_currencies

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_currencies(expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::PagedResource} with {GogoKit::Currency} :items ' \
       'created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('currencies.json'))
      currencies = client.get_currencies
      expect(currencies).to be_an_instance_of(GogoKit::PagedResource)
      expect(currencies.items[0])
        .to be_an_instance_of(GogoKit::Currency)
    end
  end
end
