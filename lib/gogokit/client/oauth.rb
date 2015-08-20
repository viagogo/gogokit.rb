require 'base64'
require 'gogokit/oauth_token'
require 'gogokit/utils'

module GogoKit
  class Client
    # OAuth authentication methods for {GogoKit::Client}
    module OAuth
      include GogoKit::Utils

      # Get an OAuth access token
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#authentication
      # @param [String] grant_type The grant type to use to get the token
      # @param [Hash] options Token request information
      # @return [GogoKit::OAuthToken] The OAuth token
      def get_access_token(grant_type, options = {})
        object_from_response(GogoKit::OAuthToken,
                             GogoKit::OAuthTokenRepresenter,
                             :post,
                             oauth_token_endpoint,
                             body: token_request_body(grant_type, options),
                             headers: token_request_headers)
      end

      # Get an OAuth access token for an application.
      #
      # @see
      # http://viagogo.github.io/developer.viagogo.net/#client-credentials-grant
      # @param [Hash] options Token request information
      # @return [GogoKit::OAuthToken] The OAuth token
      def get_client_access_token(options = {})
        get_access_token('client_credentials', options)
      end

      private

      def token_request_body(grant_type, options)
        body = options || {}
        body[:grant_type] = grant_type
        body
      end

      def token_request_headers
        credentials = "#{client_id}:#{client_secret}"
        basic_header_value = Base64.encode64(credentials).delete("\n")
        {
          content_type: 'application/x-www-form-urlencoded',
          accept: 'application/json',
          authorization: "Basic #{basic_header_value}"
        }
      end
    end
  end
end
