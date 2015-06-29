require 'rspec'
require 'spec_helper'

describe GogoKit::Client::SellerListing do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  let(:root) do
    self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/')
    root = GogoKit::Root.new
    root.links = {
      'self' => self_link
    }
    root
  end

  describe '#get_seller_listing' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_seller_listing(-1)
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request built from the self link of the root resource' do
      self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://apiroot.com')
      root = GogoKit::Root.new
      root.links = {'self' => self_link}
      expected_url = self_link.href + '/sellerlistings/55'
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_seller_listing 55

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_seller_listing(-1, expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::SellerListing} created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('seller_listing.json'))
      genres = client.get_seller_listing(-1)
      expect(genres).to be_an_instance_of(GogoKit::SellerListing)
    end
  end

  describe '#get_seller_listings' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_seller_listings
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request built from the self link of the root resource' do
      self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://apiroot.com')
      root = GogoKit::Root.new
      root.links = {'self' => self_link}
      expected_url = self_link.href + '/sellerlistings'
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_seller_listings

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_seller_listings expected_options

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::PagedResource} with {GogoKit::SellerListing}' \
       ':items created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('seller_listings.json'))
      seller_listings = client.get_seller_listings
      expect(seller_listings).to be_an_instance_of(GogoKit::PagedResource)
      expect(seller_listings.items[0])
        .to be_an_instance_of(GogoKit::SellerListing)
    end
  end
end
