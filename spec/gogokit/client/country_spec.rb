require 'rspec'
require 'spec_helper'

describe GogoKit::Client::Country do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  let(:root) do
    self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/')
    countries_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/ct')
    root = GogoKit::Root.new
    root.links = {
      'self' => self_link,
      'viagogo:countries' => countries_link
    }
    root
  end

  describe '#get_country' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_country 'BB'
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request built from the self link of the root resource' do
      self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://apiroot.com')
      root = GogoKit::Root.new
      root.links = {'self' => self_link}
      expected_url = self_link.href + '/countries/EX'
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_country 'EX'

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_country('BB', expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::Country} created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('country.json'))
      countries = client.get_country 'BB'
      expect(countries).to be_an_instance_of(GogoKit::Country)
    end
  end

  describe '#get_countries' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_countries
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request to the viagogo:countries rel on the root resource' do
      expected_url = 'http://apiv2.com/countries'
      countries_link = Roar::Hypermedia::Hyperlink.new(href: expected_url)
      root = GogoKit::Root.new
      root.links = {'viagogo:countries' => countries_link}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_countries

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_countries(expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::PagedResource} with {GogoKit::Country} :items ' \
       'created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('countries.json'))
      countries = client.get_countries
      expect(countries).to be_an_instance_of(GogoKit::PagedResource)
      expect(countries.items[0])
        .to be_an_instance_of(GogoKit::Country)
    end
  end
end
