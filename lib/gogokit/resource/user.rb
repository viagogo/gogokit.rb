require 'gogokit/resource'

module GogoKit
  # @see http://developer.viagogo.net/#user
  class User < Resource
    attr_accessor :full_name,
                  :email,
                  :primary_phone,
                  :email_optin
  end

  module UserRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :full_name
    property :email
    property :primary_phone
    property :email_optin
  end
end
