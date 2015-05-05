require 'addressable/uri'
require 'addressable/template'
require 'gogokit/configuration'
require 'gogokit/connection'
require 'gogokit/error'
require 'gogokit/client/oauth'
require 'gogokit/client/root'
require 'gogokit/client/search'
require 'gogokit/version'

module GogoKit
  # Client for the viagogo API
  #
  # @see http://developer.viagogo.net
  class Client
    include GogoKit::Configuration
    include GogoKit::Connection
    include GogoKit::Client::OAuth
    include GogoKit::Client::Root
    include GogoKit::Client::Search

    attr_accessor :client_id,
                  :client_secret,
                  :access_token

    # Initializes a new {GogoKit::Client}
    #
    # @param options [Hash]
    # @option options [String] :client_id Client Id of your application
    # @option options [String] :client_secret Client Secret of your application
    # @option options [String] :oauth_token_endpoint Endpoint for obtaining
    # OAuth access tokens
    # @raise [GogoKit::Error::ConfigurationError] Error is raised when supplied
    # client credentials are not a String or Symbol.
    # @return [GogoKit::Client]
    def initialize(options = {})
      options.each do |key, value|
        send(:"#{key}=", value)
      end
      yield self if block_given?

      validate_credential_type!
      validate_configuration!
    end

    # The User-Agent header used when making HTTP requests
    #
    # @return [String]
    def user_agent
      @user_agent ||= "GogoKit Ruby Gem #{GogoKit::VERSION}"
    end

    # Perform an HTTP DELETE request
    #
    # @return [Hash] object containing response information
    def delete(url, options = {})
      request(:delete, url, options)
    end

    # Perform an HTTP GET request
    #
    # @return [Hash] object containing response information
    def get(url, options = {})
      request(:get, url, options)
    end

    # Perform an HTTP HEAD request
    #
    # @return [Hash] object containing response information
    def head(url, options = {})
      request(:head, url, options)
    end

    # Perform an HTTP PATCH request
    #
    # @return [Hash] object containing response information
    def patch(url, options = {})
      request(:patch, url, options)
    end

    # Perform an HTTP POST request
    #
    # @return [Hash] object containing response information
    def post(url, options = {})
      request(:post, url, options)
    end

    # Perform an HTTP PUT request
    #
    # @return [Hash] object containing response information
    def put(url, options = {})
      request(:put, url, options)
    end

    private

    # Perform an HTTP request
    #
    # @return [Hash] object containing response information
    def request(method, url, options = {})
      options ||= {}
      url = expand_url(url, options[:params])
      try_add_authorization_header(options)

      connection.send(method.to_sym, url, options[:body], options[:headers]).env
    end

    # Expands a URI template with the given parameters
    def expand_url(url, params)
      params ||= {}
      template = url.respond_to?(:expand) ? url : Addressable::Template.new(url)
      if template.variables.empty? && !params.empty?
        # the URI isn't templated so just append the query parameters
        non_templated_url = Addressable::URI.parse(url)
        existing_query_values = non_templated_url.query_values(Hash) || {}
        non_templated_url.query_values = existing_query_values.merge(params)
        return non_templated_url.to_s
      end

      template.expand(params || {}).to_s
    end

    def try_add_authorization_header(options)
      options[:headers] ||= {}
      return unless options[:headers]['Authorization'].nil? &&
                    options[:headers][:authorization].nil?

      # Add an Authorization header since we don't have one yet
      options[:headers]['Authorization'] = "Bearer #{access_token}"
    end

    # @return [Hash]
    def credentials
      {
        client_id: client_id,
        client_secret: client_secret,
        access_token: access_token
      }
    end

    # Ensures that all credentials set during configuration are of a valid type.
    # Valid types are String and Symbol.
    #
    # @raise [GogoKit::Error::ConfigurationError] Error is raised when supplied
    # credentials are not a String or Symbol.
    def validate_credential_type!
      credentials.each do |credential, value|
        next if value.nil? || value.is_a?(String) || value.is_a?(Symbol)
        fail(ConfigurationError,
             "Invalid #{credential} specified: #{value.inspect} must be a" \
             ' string or symbol.')
      end
    end
  end
end
