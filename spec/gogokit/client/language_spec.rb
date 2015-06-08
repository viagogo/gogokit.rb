require 'rspec'
require 'spec_helper'

describe GogoKit::Client::Language do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  let(:root) do
    self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/')
    languages_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/lg')
    root = GogoKit::Root.new
    root.links = {
      'self' => self_link,
      'viagogo:languages' => languages_link
    }
    root
  end

  describe '#get_language' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_language 'BDS'
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request built from the self link of the root resource' do
      self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://apiroot.com')
      root = GogoKit::Root.new
      root.links = {'self' => self_link}
      expected_url = self_link.href + '/languages/EX'
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_language 'EX'

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_language('BDS', expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::Language} created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('language.json'))
      languages = client.get_language 'BB'
      expect(languages).to be_an_instance_of(GogoKit::Language)
    end
  end

  describe '#get_languages' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_languages
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request to the viagogo:languages rel on root resource' do
      expected_url = 'http://apiv2.com/languages'
      languages_link = Roar::Hypermedia::Hyperlink.new(href: expected_url)
      root = GogoKit::Root.new
      root.links = {'viagogo:languages' => languages_link}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_languages

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_languages(expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::PagedResource} with {GogoKit::Language} :items ' \
       'created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('languages.json'))
      languages = client.get_languages
      expect(languages).to be_an_instance_of(GogoKit::PagedResource)
      expect(languages.items[0])
        .to be_an_instance_of(GogoKit::Language)
    end
  end
end
