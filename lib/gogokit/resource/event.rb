require 'gogokit/resource'
require 'roar/coercion'

module GogoKit
  # An event on the viagogo platform.
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#event
  class Event < Resource
    attr_accessor :id,
                  :name,
                  :start_date,
                  :date_confirmed
  end

  module EventRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :name
    property :start_date, type: DateTime
    property :date_confirmed
  end
end
