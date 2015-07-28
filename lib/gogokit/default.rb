module GogoKit
  # Default configuration options for {GogoKit::Client}
  module Default
    # Default API root endpoint
    API_ROOT_ENDPOINT = 'https://api.viagogo.net/v2'.freeze

    # Default OAuth token endpoint
    OAUTH_TOKEN_ENDPOINT = 'https://www.viagogo.com/secure/oauth2/token'.freeze

    class << self
      def client_id
        ENV['GOGOKIT_CLIENT_ID']
      end

      def client_secret
        ENV['GOGOKIT_CLIENT_SECRET']
      end

      def access_token
        ENV['GOGOKIT_ACCESS_TOKEN']
      end

      def api_root_endpoint
        ENV['GOGOKIT_API_ROOT_ENDPOINT'] || GogoKit::Default::API_ROOT_ENDPOINT
      end

      def oauth_token_endpoint
        ENV['GOGOKIT_OAUTH_TOKEN_ENDPOINT'] ||
          GogoKit::Default::OAUTH_TOKEN_ENDPOINT
      end
    end
  end
end
