require 'uri'
require 'gogokit/default'

module GogoKit
  # Configuration options for {GogoKit::Client} or falls back to
  # {GogoKit::Default}
  module Configuration
    attr_writer :oauth_token_endpoint

    # Gets the endpoint for obtaining OAuth access tokens
    def oauth_token_endpoint
      @oauth_token_endpoint || GogoKit::Default::OAUTH_TOKEN_ENDPOINT
    end

    private

    def validate_configuration!
      return if oauth_token_endpoint =~ /\A#{URI.regexp}\z/

      fail(ConfigurationError,
           'Invalid :oauth_token_endpoint specified: ' \
           "#{oauth_token_endpoint.inspect} must be a valid URL")
    end
  end
end
