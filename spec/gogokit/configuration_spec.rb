require 'rspec'
require 'spec_helper'

describe GogoKit::Configuration do
  let(:client) do
    GogoKit::Client.new(client_id: 'CK',
                        client_secret: 'CS')
  end

  describe '#oauth_token_endpoint' do
    context 'when no value is given' do
      it 'return default token endpoint' do
        client = GogoKit::Client.new
        expect(client.oauth_token_endpoint)
          .to eq(GogoKit::Default::OAUTH_TOKEN_ENDPOINT)
      end
    end
  end
end
