require 'rspec'
require 'spec_helper'

describe 'GogoKit::Client::OAuth' do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK', client_secret: 'CS')
  end

  describe '#get_access_token' do
    it 'performs a post request' do
      stub_request(:any, /.*/).to_return(body: '{}')
      client.get_access_token('grant_type')
      expect(a_request(:post, /.*/)).to have_been_made
    end

    it 'performs a request to the oauth_token_endpoint' do
      expected_url = 'http://api.com/token'
      client = GogoKit::Client.new(client_id: 'client_id',
                                   client_secret: 'client_secret',
                                   oauth_token_endpoint: expected_url)
      allow(client).to receive(:oauth_token_endpoint).and_return(expected_url)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_access_token('grant_type')

      expect(client).to have_received(:request).with(anything,
                                                     expected_url,
                                                     anything)
    end

    it 'passes the given grant_type in the request body' do
      expected_grant_type = 'my_custom_grant_type'
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_access_token(expected_grant_type, foo: [1, 2])

      expect(client).to have_received(:request) do |_, _, options|
        expect(options[:body][:grant_type]).to eq(expected_grant_type)
      end
    end

    it 'passes the given options in the request body' do
      expected_body = {foo: [1, 2], scope: 'read:user'}
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_access_token('grant_type', expected_body)

      expect(client).to have_received(:request) do |_, _, options|
        expect(options[:body]).to eq(expected_body)
      end
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

    it 'uses Basic Authorization header calculated from credentials' do
      client_id = 'D92wmmKuAwH2CHjQONxQAr8+jC4='
      client_secret = 'Uic9N78UNgVRqoLzZ2TAM2nzfs8='
      expected_basic_header = 'Basic RDkyd21tS3VBd0gyQ0hqUU9OeFFBcjgrakM0PTp' \
                              'VaWM5Tjc4VU5nVlJxb0x6WjJUQU0ybnpmczg9'
      client = GogoKit::Client.new(client_id: client_id,
                                   client_secret: client_secret)
      allow(client).to receive(:request).and_return(body: '{}', status: 200)
      client.get_access_token('grant_type')

      expect(client).to have_received(:request) do |_, _, options|
        expect(options[:headers][:authorization])
          .to eq(expected_basic_header)
      end
    end

    it 'returns {GogoKit::OAuthToken} created from the response' do
      stub_request(:any, /.*/).to_return(body: fixture('oauth_token.json'))
      token = client.get_access_token('grant_type')
      expect(token).to be_an_instance_of(GogoKit::OAuthToken)
    end
  end

  describe '#get_client_access_token' do
    it 'passes client_credentials grant type to #get_access_token' do
      expected_grant_type = 'client_credentials'
      allow(client).to receive(:get_access_token)
      client.get_client_access_token

      expect(client)
        .to have_received(:get_access_token) do |actual_grant_type, _|
          expect(actual_grant_type).to eq(expected_grant_type)
        end
    end

    it 'passes given options to #get_access_token' do
      expected_options = {a: [1, 2], z: 'foo'}
      allow(client).to receive(:get_access_token)
      client.get_client_access_token(expected_options)

      expect(client).to have_received(:get_access_token) do |_, actual_options|
        expect(actual_options).to eq(expected_options)
      end
    end

    it 'returns the {GogoKit::OAuthToken} returned by #get_access_token' do
      expected_token = GogoKit::OAuthToken.new
      allow(client).to receive(:get_access_token).and_return(expected_token)

      actual_token = client.get_client_access_token

      expect(actual_token).to eq(expected_token)
    end
  end

  describe '#get_authorization_url' do
    it 'returns a URL of the given values' do
      redirect_uri = 'https://myapp.com/callback'
      state = 'abc123'
      expected_url = "#{client.authorization_endpoint}?client_id=" \
                     "#{client.client_id}&response_type=code&redirect_uri=" \
                     "#{redirect_uri}&scope=S1%20S2&state=#{state}"
      actual_url =
          client.get_authorization_url redirect_uri, %w(S1 S2), state

      expect(actual_url).to eq(expected_url)
    end
  end

  describe '#get_authorization_code_access_token' do
    it 'passes authorization_code grant type to #get_access_token' do
      expected_grant_type = 'authorization_code'
      allow(client).to receive(:get_access_token)
      client.get_authorization_code_access_token 'code',
                                                 'http://myapp.com/cb',
                                                 %w(S1 S2)

      expect(client).to have_received(:get_access_token) do |grant_type, _|
        expect(grant_type).to eq(expected_grant_type)
      end
    end

    it 'passes given params and options to #get_access_token' do
      options = {
        a: [1, 2],
        z: 'foo'
      }
      expected_options = {
        a: [1, 2],
        z: 'foo',
        code: 'code',
        redirect_uri: 'http://cb.com',
        scope: 'S1 S2'
      }
      allow(client).to receive(:get_access_token)
      client.get_authorization_code_access_token(
        expected_options[:code],
        expected_options[:redirect_uri],
        %w(S1 S2),
        options)

      expect(client).to have_received(:get_access_token) do |_, actual_opts|
        expect(actual_opts).to eq(expected_options)
      end
    end

    it 'returns the {GogoKit::OAuthToken} returned by #get_access_token' do
      expected_token = GogoKit::OAuthToken.new
      allow(client).to receive(:get_access_token).and_return(expected_token)

      actual_token =
        client.get_authorization_code_access_token 'code',
                                                   'http://myapp.com/cb',
                                                   %w(S1 S2)

      expect(actual_token).to eq(expected_token)
    end
  end

  describe '#get_refresh_token' do
    it 'passes refresh_token grant type to #get_access_token' do
      expected_grant_type = 'refresh_token'
      allow(client).to receive(:get_access_token)
      client.get_refresh_token GogoKit::OAuthToken.new

      expect(client).to have_received(:get_access_token) do |grant_type, _|
        expect(grant_type).to eq(expected_grant_type)
      end
    end

    it 'passes values from the given token to #get_access_token' do
      options = {
        a: [1, 2],
        z: 'foo'
      }
      expected_options = {
        a: [1, 2],
        z: 'foo',
        refresh_token: 'refresh me!',
        scope: 'S1 S2'
      }
      token = GogoKit::OAuthToken.new
      token.refresh_token = expected_options[:refresh_token]
      token.scope = expected_options[:scope]
      allow(client).to receive(:get_access_token)
      client.get_refresh_token(token, options)

      expect(client).to have_received(:get_access_token) do |_, actual_opts|
        expect(actual_opts).to eq(expected_options)
      end
    end

    it 'returns the {GogoKit::OAuthToken} returned by #get_access_token' do
      expected_token = GogoKit::OAuthToken.new
      allow(client).to receive(:get_access_token).and_return(expected_token)

      actual_token =
          client.get_authorization_code_access_token 'code',
                                                     'http://myapp.com/cb',
                                                     %w(S1 S2)

      expect(actual_token).to eq(expected_token)
    end
  end
end
