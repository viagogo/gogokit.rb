require 'addressable/uri'
require 'addressable/template'
require 'gogokit/connection'
require 'gogokit/version'

module GogoKit
  # Client for the viagogo API
  #
  # @see http://developer.viagogo.net
  class Client
    include GogoKit::Connection

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
      url = expand_url(url, options[:params])
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
  end
end
