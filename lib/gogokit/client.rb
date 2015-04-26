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

    private

    # Perform an HTTP request
    #
    # @return [Hash] object containing response information
    def request(method, url, body = nil, params = {}, headers = {})
      url = expand_url(url, params)
      connection.send(method.to_sym, url, body, headers).env
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
