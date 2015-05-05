require 'gogokit/resource'

module GogoKit
  # Represents a grouping of events or other categories
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#category
  class Category < Resource
    attr_accessor :id,
                  :name
  end

  module CategoryRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :name
  end
end
