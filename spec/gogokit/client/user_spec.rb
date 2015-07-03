require 'rspec'
require 'spec_helper'

describe GogoKit::Client::User do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  let(:root) do
    user_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/user')
    root = GogoKit::Root.new
    root.links = {
      'viagogo:user' => user_link
    }
    root
  end

  describe '#get_user' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_user
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request to the viagogo:user rel on the root resource' do
      expected_url = 'http://apiv2.com/user'
      user_link = Roar::Hypermedia::Hyperlink.new(href: expected_url)
      root = GogoKit::Root.new
      root.links = {'viagogo:user' => user_link}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_user

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_user(expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::User} created from the response'  do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('user.json'))
      user = client.get_user
      expect(user).to be_an_instance_of(GogoKit::User)
    end
  end
end
