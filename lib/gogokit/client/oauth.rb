require 'base64'
require 'open-uri'
require 'gogokit/oauth_token'
require 'gogokit/utils'

module GogoKit
  # OAuth authentication methods for {GogoKit::Client}
  module OAuth
    include GogoKit::Utils

    # Get an OAuth access token
    #
    # @see http://viagogo.github.io/developer.viagogo.net/#authentication
    # @param [String] grant_type The grant type to use to get the token
    # @param [Hash] options Token request information
    def get_access_token(grant_type, options = {})
      object_from_response(GogoKit::OAuthToken,
                           GogoKit::OAuthTokenRepresenter,
                           :post,
                           oauth_token_endpoint,
                           body: token_request_body(grant_type, options),
                           headers: token_request_headers)
    end

    private

    def token_request_body(grant_type, options)
      body = options || {}
      body[:grant_type] = grant_type
      body
    end

    def token_request_headers
      # TODO: Calculate Basic Authorization header
      {
        content_type: 'application/x-www-form-urlencoded',
        accept: 'application/json'
      }
    end
  end
end
