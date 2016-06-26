module GogoKit
  # Default configuration options for {GogoKit::Client}
  module Default
    # Default API root endpoints
    API_ROOT_ENDPOINTS = {
      production: 'https://api.viagogo.net/v2'.freeze,
      sandbox: 'https://sandbox.api.viagogo.net/v2'.freeze
    }

    # Default OAuth token endpoints
    OAUTH_TOKEN_ENDPOINTS = {
      production: 'https://account.viagogo.com/oauth2/token'.freeze,
      sandbox: 'https://sandbox.account.viagogo.com/oauth2/token'.freeze
    }

    # Default Authorize endpoints
    AUTHORIZATION_ENDPOINTS = {
      production: 'https://account.viagogo.com/authorize'.freeze,
      sandbox: 'https://sandbox.account.viagogo.com/authorize'.freeze
    }

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

      def api_environment
        env_api_environment = ENV['GOGOKIT_API_ENVIRONMENT']
        env_api_environment.nil? ? :production : env_api_environment.to_sym
      end

      def api_root_endpoint
        ENV['GOGOKIT_API_ROOT_ENDPOINT'] ||
          GogoKit::Default::API_ROOT_ENDPOINTS[api_environment]
      end

      def oauth_token_endpoint
        ENV['GOGOKIT_OAUTH_TOKEN_ENDPOINT'] ||
          GogoKit::Default::OAUTH_TOKEN_ENDPOINTS[api_environment]
      end

      def authorization_endpoint
        ENV['GOGOKIT_AUTHORIZATION_ENDPOINT'] ||
          GogoKit::Default::AUTHORIZATION_ENDPOINTS[api_environment]
      end
    end
  end
end
