require 'rspec'
require 'spec_helper'

describe 'GogoKit::OAuth' do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK',
                        client_secret: 'CS')
  end

  describe '#get_access_token' do
    it 'performs a post request' do
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_access_token('grant_type')
      expect(a_request(:post, /.*/)).to have_been_made
    end

    it 'performs a request to the oauth_token_endpoint' do
      expected_url = 'http://api.com/token'
      allow(client).to receive(:oauth_token_endpoint).and_return(expected_url)
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_access_token('grant_type')
      expect(a_request(:any, expected_url)).to have_been_made
    end

    it 'passes the given grant_type in the request body' do
      expected_grant_type = 'my_custom_grant_type'
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_access_token(expected_grant_type, foo: [1, 2])
      expect(a_request(:any, /.*/)
             .with do |req|
               req.body[:grant_type] == expected_grant_type
             end).to have_been_made
    end

    it 'passes the given options in the request body' do
      expected_body = {foo: [1, 2], scope: 'read:user'}
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_access_token('grant_type', expected_body)
      expect(a_request(:any, /.*/)
                 .with { |req| req.body == expected_body })
        .to have_been_made
    end

    it 'passes application/json Accept header' do
      expected_accept = 'application/json'
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_access_token('grant_type')
      expect(a_request(:any, /.*/)
                .with(headers: {'Accept' => expected_accept}))
        .to have_been_made
    end

    it 'uses application/x-www-form-urlencoded Content-Type header' do
      expected_content_type = 'application/x-www-form-urlencoded'
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_access_token('grant_type')
      expect(a_request(:any, /.*/)
                 .with(headers: {'Content-Type' => expected_content_type}))
        .to have_been_made
    end

    it 'returns {GogoKit::OAuthToken} created from the response' do
      stub_request(:any, /.*/).to_return(body: fixture('oauth_token.json'))
      token = client.get_access_token('grant_type')
      expect(token).to be_an_instance_of(GogoKit::OAuthToken)
    end
  end
end
