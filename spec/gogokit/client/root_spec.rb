require 'rspec'
require 'spec_helper'

describe GogoKit::Client::Root do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  describe '#get_root' do
    it 'performs a get request' do
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_root
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request to the api_root_endpoint' do
      expected_url = 'http://api.com/root'
      client = GogoKit::Client.new(client_id: 'client_id',
                                   client_secret: 'client_secret',
                                   api_root_endpoint: expected_url)
      allow(client).to receive(:api_root_endpoint).and_return(expected_url)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_root

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_root(expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::Root} created from the response' do
      stub_request(:any, /.*/).to_return(body: fixture('root.json'))
      root = client.get_root
      expect(root).to be_an_instance_of(GogoKit::Root)
    end
  end
end
