require 'rspec'
require 'spec_helper'

describe GogoKit::Client::Category do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  let(:root) do
    genres_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/s')
    root = GogoKit::Root.new
    root.links = {'viagogo:genres' => genres_link}
    root
  end

  describe '#get_genres' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_genres
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request to the viagogo:genres link on the root resource' do
      expected_url = 'http://apiv2.com/genres'
      genres_link = Roar::Hypermedia::Hyperlink.new(href: expected_url)
      root = GogoKit::Root.new
      root.links = {'viagogo:genres' => genres_link}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_genres

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_genres(expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::PagedResource} with {GogoKit::Category} :items ' \
       'created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('genres.json'))
      genres = client.get_genres
      expect(genres).to be_an_instance_of(GogoKit::PagedResource)
      expect(genres.items[0])
        .to be_an_instance_of(GogoKit::Category)
    end
  end
end
