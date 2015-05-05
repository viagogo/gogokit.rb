require 'gogokit/resource'

module GogoKit
  # @see http://viagogo.github.io/developer.viagogo.net/#country
  class Country < Resource
    attr_accessor :code,
                  :name
  end

  module CountryRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :code
    property :name
  end
end
