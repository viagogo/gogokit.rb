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
      # @see http://developer.viagogo.net/#application-only-authentication-flow
      # @param [Hash] options Token request information
      # @return [GogoKit::OAuthToken] The OAuth token
      def get_client_access_token(options = {})
        get_access_token('client_credentials', options)
      end

      # Gets the URL where applications can obtain a users consent to make API
      # calls on their behalf.
      # @see http://developer.viagogo.net/#user-login-authentication-flow
      # @param [String] redirect_uri Application redirect URL where the
      # authorization code is sent. This must match the URL registered for your
      # application.
      # @param [Array] scopes The scopes that specify the type of access that is
      # needed.
      # @param [String] state An opaque value used to maintain state between the
      # authorize request and the callback.
      def get_authorization_url(redirect_uri, scopes, state = nil)
        scope_value = scopes.nil? ? '' : scopes.join('%20')
        "#{authorization_endpoint}?client_id=#{client_id}&response_type=code&" \
        "redirect_uri=#{redirect_uri}&scope=#{scope_value}&state=#{state}"
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
