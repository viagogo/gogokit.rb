require 'rspec'
require 'spec_helper'

describe GogoKit::Client do
  let(:client) { described_class.new }

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
          client.send(:request, method, non_templated_url, nil, var: 'value')
          expect(a_request(:any, expected_url)).to have_been_made
        end

        it 'makes an HTTP request with an expanded Level 1 URI template' do
          templated_url = 'http://host.com/path/{hello}'
          expected_url = 'http://host.com/path/Hello%20World%21'
          stub_request(:any, /.*/)
          client.send(:request,
                      method,
                      templated_url,
                      nil,
                      hello: 'Hello World!')
          expect(a_request(:any, expected_url)).to have_been_made
        end

        it 'makes an HTTP request with an expanded Level 2 URI template' do
          templated_url = 'http://host.com/path{+path}/here'
          expected_url = 'http://host.com/path/foo/bar/here'
          stub_request(:any, /.*/)
          client.send(:request,
                      method,
                      templated_url,
                      nil,
                      path: '/foo/bar')
          expect(a_request(:any, expected_url)).to have_been_made
        end

        it 'makes an HTTP request with an expanded Level 3 URI template' do
          templated_url = 'http://host.com/path{?x,y,empty}'
          expected_url = 'http://host.com/path?x=1024&y=768'
          stub_request(:any, /.*/)
          client.send(:request,
                      method,
                      templated_url,
                      nil,
                      x: 1024, y: 768, empty: nil)
          expect(a_request(:any, expected_url)).to have_been_made
        end

        context 'Content-Type header is not given' do
          it 'makes an HTTP request with HAL+JSON Content-Type' do
            expected_content_type = 'application/hal+json'
            stub_request(:any, /.*/)
            client.send(:request, method, 'https://api.com', nil, {}, {})
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
                        nil,
                        {},
                        'Content-Type' => expected_content_type)
            expect(a_request(:any, /.*/)
                     .with(headers: {'Content-Type' => expected_content_type}))
              .to have_been_made
          end
        end

        context 'Accept header is not given' do
          it 'makes an HTTP request with HAL+JSON Accept header' do
            expected_accept = 'application/hal+json'
            stub_request(:any, /.*/)
            client.send(:request, method, 'https://api.com', nil, {}, {})
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
                        nil,
                        {},
                        'Accept' => expected_accept)
            expect(a_request(:any, /.*/)
                       .with(headers: {'Accept' => expected_accept}))
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
          client.send(:request, method, 'https://api.com', expected_body)
          expect(a_request(:any, /.*/)
                     .with { |req| req.body == expected_body })
            .to have_been_made
        end
      end
    end
  end
end
