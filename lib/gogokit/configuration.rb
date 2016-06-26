require 'uri'
require 'gogokit/default'

module GogoKit
  # Configuration options for {GogoKit::Client} or falls back to
  # {GogoKit::Default}
  module Configuration
    attr_accessor :client_id,
                  :client_secret,
                  :access_token,
                  :api_root_endpoint,
                  :oauth_token_endpoint,
                  :authorization_endpoint

    # Reset configuration options to default values
    def reset!
      keys.each do |key|
        instance_variable_set(:"@#{key}", GogoKit::Default.send(key))
      end
      self
    end

    # Gets the current API environment in use
    #
    # @return [Symbol]
    # @raise [GogoKit::Error::ConfigurationError] Error is raised when supplied
    # environment is not :production or :sandbox.
    def api_environment
      @api_environment
    end

    # Sets the API environment to be used. Setting this value will configure the
    # values for {GogoKit::Configuration#api_root_endpoint},
    # {GogoKit::Configuration#oauth_token_endpoint} and
    # {GogoKit::Configuration#authorization_endpoint}.
    # See http://developer.viagogo.net/#sandbox-environment
    def api_environment=(api_environment)
      @api_environment = api_environment.to_sym
      validate_configuration_api_environment!

      self.api_root_endpoint =
        GogoKit::Default::API_ROOT_ENDPOINTS[@api_environment]
      self.oauth_token_endpoint =
        GogoKit::Default::OAUTH_TOKEN_ENDPOINTS[@api_environment]
      self.authorization_endpoint =
        GogoKit::Default::AUTHORIZATION_ENDPOINTS[@api_environment]
    end

    private

    def keys
      @keys ||= [
        :client_id,
        :client_secret,
        :access_token,
        :api_environment,
        :api_root_endpoint,
        :oauth_token_endpoint,
        :authorization_endpoint
      ]
    end

    # @return [Hash]
    def credentials
      {
        client_id: client_id,
        client_secret: client_secret,
        access_token: access_token
      }
    end

    def endpoints
      {
        api_root_endpoint: api_root_endpoint,
        oauth_token_endpoint: oauth_token_endpoint,
        authorization_endpoint: authorization_endpoint
      }
    end

    # Ensures that all credentials set during configuration are of a valid type.
    # Valid types are String and Symbol.
    #
    # @raise [GogoKit::Error::ConfigurationError] Error is raised when supplied
    # credentials are not a String or Symbol.
    def validate_configuration_credentials!
      credentials.each do |credential, value|
        next if value.nil? || value.is_a?(String) || value.is_a?(Symbol)
        fail(ConfigurationError,
             "Invalid #{credential} specified: #{value.inspect} must be a" \
             ' string or symbol.')
      end
    end

    def validate_configuration_endpoints!
      endpoints.each do |endpoint, value|
        next if !value.nil? && value =~ /\A#{URI.regexp}\z/

        fail(ConfigurationError,
             "Invalid #{endpoint} specified: " \
             "#{value.inspect} must be a valid URL")
      end
    end

    def validate_configuration_api_environment!
      return if api_environment.nil? ||
                api_environment == :production ||
                api_environment == :sandbox

      fail(ConfigurationError,
           'Invalid api_environment specified: ' \
             "#{api_environment.inspect} must be :production or :sandbox")
    end
  end
end
