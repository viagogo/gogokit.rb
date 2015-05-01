require 'uri'
require 'gogokit/default'

module GogoKit
  # Configuration options for {GogoKit::Client} or falls back to
  # {GogoKit::Default}
  module Configuration
    attr_writer :oauth_token_endpoint

    # The endpoint for the API root resource
    def api_root_endpoint
      nil
    end

    # The endpoint for obtaining OAuth access tokens
    def oauth_token_endpoint
      @oauth_token_endpoint || GogoKit::Default::OAUTH_TOKEN_ENDPOINT
    end

    private

    def endpoints
      {
        # api_root_endpoint: api_root_endpoint,
        oauth_token_endpoint: oauth_token_endpoint
      }
    end

    def validate_configuration!
      endpoints.each do |endpoint, value|
        next if !value.nil? && value =~ /\A#{URI.regexp}\z/

        fail(ConfigurationError,
             "Invalid #{endpoint} specified: " \
             "#{value.inspect} must be a valid URL")
      end
    end
  end
end
