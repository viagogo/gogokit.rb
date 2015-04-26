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
    def request(method, url, params = {}, headers = {})
      connection.send(method.to_sym, url, params, headers).env
    end
  end
end
