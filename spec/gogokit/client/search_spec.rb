require 'rspec'
require 'spec_helper'

describe GogoKit::Client::Search do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  let(:root) do
    search_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/s')
    root = GogoKit::Root.new
    root.links = {'viagogo:search' => search_link}
    root
  end

  describe '#search' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.search 'foo'
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request to the viagogo:search link on the root resource' do
      expected_url = 'http://apiv2.com/search'
      search_link = Roar::Hypermedia::Hyperlink.new(href: expected_url)
      root = GogoKit::Root.new
      root.links = {'viagogo:search' => search_link}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.search 'foo'

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.search('foo', expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'passes the given query as params in the request' do
      expected_query = 'one direction'
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.search(expected_query, params: {foo: 5}, headers: {bar: '50'})

      expect(client).to have_received(:request) do |_, _, options|
        expect(options[:params][:query]).to eq(expected_query)
      end
    end

    it 'returns {GogoKit::PagedResource} with {GogoKit::SearchResult} :items ' \
       'created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('search_result.json'))
      search_results = client.search 'one direction'
      expect(search_results).to be_an_instance_of(GogoKit::PagedResource)
      expect(search_results.items[0])
        .to be_an_instance_of(GogoKit::SearchResult)
    end
  end
end
