require 'addressable/uri'
require 'addressable/template'
require 'gogokit/configuration'
require 'gogokit/connection'
require 'gogokit/error'
require 'gogokit/client/address'
require 'gogokit/client/category'
require 'gogokit/client/country'
require 'gogokit/client/currency'
require 'gogokit/client/event'
require 'gogokit/client/language'
require 'gogokit/client/listing'
require 'gogokit/client/metro_area'
require 'gogokit/client/oauth'
require 'gogokit/client/payment_method'
require 'gogokit/client/root'
require 'gogokit/client/search'
require 'gogokit/client/seller_listing'
require 'gogokit/client/user'
require 'gogokit/client/venue'
require 'gogokit/version'

module GogoKit
  # Client for the viagogo API
  #
  # @see http://developer.viagogo.net
  class Client
    include GogoKit::Configuration
    include GogoKit::Connection
    include GogoKit::Client::Address
    include GogoKit::Client::Category
    include GogoKit::Client::Country
    include GogoKit::Client::Currency
    include GogoKit::Client::Event
    include GogoKit::Client::Language
    include GogoKit::Client::Listing
    include GogoKit::Client::MetroArea
    include GogoKit::Client::OAuth
    include GogoKit::Client::PaymentMethod
    include GogoKit::Client::Root
    include GogoKit::Client::Search
    include GogoKit::Client::SellerListing
    include GogoKit::Client::User
    include GogoKit::Client::Venue

    # Initializes a new {GogoKit::Client}
    #
    # @param options [Hash]
    # @option options [String] :client_id Client Id of your application
    # @option options [String] :client_secret Client Secret of your application
    # @option options [String] :api_root_endpoint Endpoint where the API root
    # is located
    # @option options [String] :oauth_token_endpoint Endpoint for obtaining
    # OAuth access tokens
    # @raise [GogoKit::Error::ConfigurationError] Error is raised when supplied
    # client credentials are not a String or Symbol.
    # @return [GogoKit::Client]
    def initialize(options = {})
      reset!

      options.each do |key, value|
        send(:"#{key}=", value)
      end
      yield self if block_given?

      validate_configuration_credentials!
      validate_configuration_api_environment!
      validate_configuration_endpoints!
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
  end
end
