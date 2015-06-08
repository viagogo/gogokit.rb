require 'gogokit/resource'

module GogoKit
  # @see http://viagogo.github.io/developer.viagogo.net/#tickettype
  class TicketType < Resource
    attr_accessor :type,
                  :name
  end

  module TicketTypeRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :type
    property :name
  end
end
