require 'ostruct'
require 'representable/json'

module GogoKit
  # An OAuth access token that can be used to access the viagogo API
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#authentication
  class OAuthToken < OpenStruct
  end

  # A representer for {GogoKit::OAuthToken}
  module OAuthTokenRepresenter
    include Representable::JSON

    property :access_token
    property :token_type
    property :expires_in
    property :scope
    property :refresh_token
  end
end
