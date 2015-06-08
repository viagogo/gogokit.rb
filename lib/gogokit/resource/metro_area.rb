require 'gogokit/resource'

module GogoKit
  # A metropolitan region that contains venues where events are taking place
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#metroarea
  class MetroArea < Resource
    attr_accessor :id,
                  :name
  end

  module MetroAreaRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :name
  end

  module MetroAreasRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: MetroArea,
               extend: MetroAreaRepresenter,
               embedded: true
  end
end
