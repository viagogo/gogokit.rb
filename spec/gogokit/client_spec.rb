require 'rspec'
require 'spec_helper'

describe GogoKit::Client do
  let(:client) do
    described_class.new(client_id: 'CK',
                        client_secret: 'CS')
  end

  describe '#new' do
    context 'when options are given' do
      it 'sets client_id to given value' do
        expected_client_id = 'my_client_id'
        client = described_class.new(client_id: expected_client_id)
        expect(client.client_id).to eq(expected_client_id)
      end

      it 'sets client_secret to given value' do
        expected_client_secret = 'my secret'
        client = described_class.new(client_secret: expected_client_secret)
        expect(client.client_secret).to eq(expected_client_secret)
      end

      it 'sets access_token to given value' do
        expected_access_token = 'asdfda55/'
        client = described_class.new(access_token: expected_access_token)
        expect(client.access_token).to eq(expected_access_token)
      end

      it 'sets api_root_endpoint to given value' do
        expected_root_endpoint = 'https://api.com/root'
        client = described_class.new(api_root_endpoint: expected_root_endpoint)
        expect(client.api_root_endpoint).to eq(expected_root_endpoint)
      end

      it 'sets oauth_token_endpoint to given value' do
        expected_token_url = 'https://api.com/token'
        client = described_class.new(oauth_token_endpoint: expected_token_url)
        expect(client.oauth_token_endpoint).to eq(expected_token_url)
      end

      it 'raises GogoKit::ConfigurationError when :client_id is invalid' do
        expect { described_class.new(client_id: [50, 1]) }
          .to raise_error GogoKit::ConfigurationError
      end

      it 'raises GogoKit::ConfigurationError when :consumer_secret is' \
      ' invalid' do
        expect { described_class.new(client_secret: [3, 'A']) }
          .to raise_error GogoKit::ConfigurationError
      end

      it 'raises GogoKit::ConfigurationError when :access_token is invalid' do
        expect { described_class.new(access_token: [3, 'A']) }
          .to raise_error GogoKit::ConfigurationError
      end

      it 'raises GogoKit::ConfigurationError when :api_root_endpoint is' \
      ' invalid URL' do
        expect { described_class.new(api_root_endpoint: 'http:||invalid.o') }
          .to raise_error GogoKit::ConfigurationError
      end

      it 'raises GogoKit::ConfigurationError when :oauth_token_endpoint is' \
      ' invalid URL' do
        expect { described_class.new(oauth_token_endpoint: 'http:||invalid.o') }
          .to raise_error GogoKit::ConfigurationError
      end
    end

    context 'when block is given' do
      it 'passes the current instance to be configured in the block' do
        actual_client = nil
        expected_client = described_class.new do |config|
          config.client_id = 'CI'
          config.client_secret = 'CS'
          actual_client = config
        end

        expect(actual_client.object_id).to equal(expected_client.object_id)
      end

      it 'raises GogoKit::ConfigurationError when :client_id is invalid' do
        expected = expect do
          described_class.new do |config|
            config.client_id = 50
          end
        end

        expected.to raise_error GogoKit::ConfigurationError
      end

      it 'raises GogoKit::ConfigurationError when :client_secret is invalid' do
        expected = expect do
          described_class.new do |config|
            config.client_secret = 6
          end
        end

        expected.to raise_error GogoKit::ConfigurationError
      end

      it 'raises GogoKit::ConfigurationError when :access_token is invalid' do
        expected = expect do
          described_class.new do |config|
            config.access_token = 6
          end
        end

        expected.to raise_error GogoKit::ConfigurationError
      end

      it 'raises GogoKit::ConfigurationError when :api_root_endpoint is' \
      ' invalid URL' do
        expected = expect do
          described_class.new do |config|
            config.api_root_endpoint = 'https:||invalid.org'
          end
        end

        expected.to raise_error GogoKit::ConfigurationError
      end

      it 'raises GogoKit::ConfigurationError when :oauth_token_endpoint is' \
      ' invalid URL' do
        expected = expect do
          described_class.new do |config|
            config.oauth_token_endpoint = 'https:||invalid.org'
          end
        end

        expected.to raise_error GogoKit::ConfigurationError
      end
    end
  end

  describe '#user_agent' do
    it 'returns the gem name and version' do
      version = GogoKit::VERSION
      expected_user_agent = "GogoKit Ruby Gem #{version}"
      expect(client.user_agent).to eq(expected_user_agent)
    end
  end

  describe '#request' do
    [:get, :post, :head, :put, :delete, :patch].each do |method|
      context "when HTTP method is #{method}" do
        it 'makes an HTTP request with the given method' do
          stub_request(:any, /.*/)
          client.send(:request, method, 'https://api.com/path?foo=bar')
          expect(a_request(method, /.*/)).to have_been_made
        end

        it 'makes an HTTP request with an expanded non-templated URI' do
          non_templated_url = 'https://host.com/path'
          expected_url = "#{non_templated_url}?var=value"
          stub_request(:any, /.*/)
          client.send(:request,
                      method,
                      non_templated_url,
                      params: {var: 'value'})
          expect(a_request(:any, expected_url)).to have_been_made
        end

        it 'makes an HTTP request with an expanded Level 1 URI template' do
          templated_url = 'http://host.com/path/{hello}'
          expected_url = 'http://host.com/path/Hello%20World%21'
          stub_request(:any, /.*/)
          client.send(:request,
                      method,
                      templated_url,
                      params: {hello: 'Hello World!'})
          expect(a_request(:any, expected_url)).to have_been_made
        end

        it 'makes an HTTP request with an expanded Level 2 URI template' do
          templated_url = 'http://host.com/path{+path}/here'
          expected_url = 'http://host.com/path/foo/bar/here'
          stub_request(:any, /.*/)
          client.send(:request,
                      method,
                      templated_url,
                      params: {path: '/foo/bar'})
          expect(a_request(:any, expected_url)).to have_been_made
        end

        it 'makes an HTTP request with an expanded Level 3 URI template' do
          templated_url = 'http://host.com/path{?x,y,empty}'
          expected_url = 'http://host.com/path?x=1024&y=768'
          stub_request(:any, /.*/)
          client.send(:request,
                      method,
                      templated_url,
                      params: {x: 1024, y: 768, empty: nil})
          expect(a_request(:any, expected_url)).to have_been_made
        end

        context 'Content-Type header is not given' do
          it 'makes an HTTP request with HAL+JSON Content-Type' do
            expected_content_type = 'application/hal+json'
            stub_request(:any, /.*/)
            client.send(:request, method, 'https://api.com', headers: {})
            expect(a_request(:any, /.*/)
                     .with(headers: {'Content-Type' => expected_content_type}))
              .to have_been_made
          end
        end

        context 'Content-Type header is given' do
          it 'makes an HTTP request with the given Content-Type' do
            expected_content_type = 'text/foo'
            stub_request(:any, /.*/)
            client.send(:request,
                        method,
                        'https://api.com',
                        headers: {'Content-Type' => expected_content_type})
            expect(a_request(:any, /.*/)
                     .with(headers: {'Content-Type' => expected_content_type}))
              .to have_been_made
          end
        end

        context 'Accept header is not given' do
          it 'makes an HTTP request with HAL+JSON Accept header' do
            expected_accept = 'application/hal+json'
            stub_request(:any, /.*/)
            client.send(:request, method, 'https://api.com', headers: {})
            expect(a_request(:any, /.*/)
                       .with(headers: {'Accept' => expected_accept}))
              .to have_been_made
          end
        end

        context 'Accept header is given' do
          it 'makes an HTTP request with the given Accept header' do
            expected_accept = 'application/bar'
            stub_request(:any, /.*/)
            client.send(:request,
                        method,
                        'https://api.com',
                        headers: {'Accept' => expected_accept})
            expect(a_request(:any, /.*/)
                       .with(headers: {'Accept' => expected_accept}))
              .to have_been_made
          end
        end

        context 'Authorization header is not given' do
          it 'makes an HTTP request with Bearer Authorization header' do
            access_token = 'efadfdag.dafe1234.ldasfn'
            expected_authorization = "Bearer #{access_token}"
            stub_request(:any, /.*/)
            client.access_token = access_token
            client.send(:request,
                        method,
                        'https://api.com')
            expect(a_request(:any, /.*/)
                    .with(headers: {'Authorization' => expected_authorization}))
              .to have_been_made
          end
        end

        context 'Authorization header is given' do
          it 'makes an HTTP request with the given Authorization header' do
            expected_authorization = 'Custom abc'
            stub_request(:any, /.*/)
            client.send(:request,
                        method,
                        'https://api.com',
                        headers: {'Authorization' => expected_authorization})
            expect(a_request(:any, /.*/)
                    .with(headers: {'Authorization' => expected_authorization}))
              .to have_been_made
          end

          it 'makes an HTTP request with the given :authorization header' do
            expected_authorization = 'Custom abc'
            stub_request(:any, /.*/)
            client.send(:request,
                        method,
                        'https://api.com',
                        headers: {authorization: expected_authorization})
            expect(a_request(:any, /.*/)
                    .with(headers: {'Authorization' => expected_authorization}))
              .to have_been_made
          end
        end

        it 'makes an HTTP request with user-agent set to the return value of ' \
           '#user_agent' do
          expected_user_agent = 'some user agent'
          allow(client).to receive(:user_agent).and_return(expected_user_agent)
          stub_request(:any, /.*/)
          client.send(:request, method, 'http://api.com')
          expect(a_request(:any, /.*/)
                     .with(headers: {'User-Agent' => expected_user_agent}))
            .to have_been_made
        end

        it 'returns the response env Hash' do
          expected_response_hash = {body: 'abc'}
          stub_request(:any, /.*/).to_return(expected_response_hash)
          actual_response_hash = client.send(:request,
                                             method,
                                             'http://api.com/foo')
          expect(actual_response_hash[:body])
            .to eq(expected_response_hash[:body])
        end
      end
    end

    [:post, :put, :patch].each do |method|
      context "when HTTP method is #{method}" do
        it 'makes an HTTP request with the given body' do
          expected_body = {foo: 'bar'}
          stub_request(:any, /.*/)
          client.send(:request, method, 'https://api.com', body: expected_body)
          expect(a_request(:any, /.*/)
                     .with { |req| req.body == expected_body })
            .to have_been_made
        end
      end
    end
  end

  [:get, :post, :head, :put, :delete, :patch].each do |method|
    describe "##{method}" do
      it "performs a #{method} request" do
        allow(client).to receive(:request).and_return(nil)
        client.send(method, 'https://api.com')

        expect(client).to have_received(:request).with(method,
                                                       anything,
                                                       anything)
      end

      it 'performs a request to the given URL' do
        expected_url = 'https://api.vgg.com/events'
        allow(client).to receive(:request).and_return(nil)
        client.send(method, expected_url)

        expect(client).to have_received(:request).with(anything,
                                                       expected_url,
                                                       anything)
      end

      it 'performs a request with the given options' do
        expected_options = {body: 'foo', params: {a: 5, b: 6}, headers: {}}
        allow(client).to receive(:request).and_return(nil)
        client.send(method, 'https://api.com', expected_options)

        expect(client).to have_received(:request).with(anything,
                                                       anything,
                                                       expected_options)
      end
    end
  end
end
