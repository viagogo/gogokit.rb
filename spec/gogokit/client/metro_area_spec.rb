require 'rspec'
require 'spec_helper'

describe GogoKit::Client::MetroArea do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  let(:root) do
    self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://api.com/')
    metro_areas_link = Roar::Hypermedia::Hyperlink.new(href: 'https://a.com/m')
    root = GogoKit::Root.new
    root.links = {
      'self' => self_link,
      'viagogo:metro_areas' => metro_areas_link
    }
    root
  end

  describe '#get_metro_area' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_metro_area(-1)
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request built from the self link of the root resource' do
      self_link = Roar::Hypermedia::Hyperlink.new(href: 'https://apiroot.com')
      root = GogoKit::Root.new
      root.links = {'self' => self_link}
      expected_url = self_link.href + '/metro_areas/514'
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_metro_area(514)

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_metro_area(-1, expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::MetroArea} created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('metro_area.json'))
      metro_areas = client.get_metro_area(-1)
      expect(metro_areas).to be_an_instance_of(GogoKit::MetroArea)
    end
  end

  describe '#get_metro_areas' do
    it 'performs a get request' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_metro_areas
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it 'performs a request to the viagogo:metro_areas rel on the API root' do
      expected_url = 'http://apiv2.com/metro_areas'
      metro_areas_link = Roar::Hypermedia::Hyperlink.new(href: expected_url)
      root = GogoKit::Root.new
      root.links = {'viagogo:metro_areas' => metro_areas_link}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_metro_areas

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given options in the request' do
      expected_options = {params: {foo: 5}, headers: {bar: '50'}}
      allow(client).to receive(:get_root).and_return(root)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_metro_areas(expected_options)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options).to eq(expected_options)
      end
    end

    it 'returns {GogoKit::PagedResource} with {GogoKit::MetroArea} :items ' \
       'created from the response' do
      allow(client).to receive(:get_root).and_return(root)
      stub_request(:any, /.*/).to_return(body: fixture('metro_areas.json'))
      metro_areas = client.get_metro_areas
      expect(metro_areas).to be_an_instance_of(GogoKit::PagedResource)
      expect(metro_areas.items[0])
        .to be_an_instance_of(GogoKit::MetroArea)
    end
  end
end
