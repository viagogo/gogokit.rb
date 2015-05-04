require 'gogokit/resource'
require 'gogokit/paged_resource'

module GogoKit
  # A result of a search query
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#searchresult
  class SearchResult < Resource
    attr_accessor :title,
                  :type,
                  :type_description
    # TODO: Embedded properties
  end

  # Representer for {GogoKit::SearchResult}
  module SearchResultRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :title
    property :type
    property :type_description
  end

  # Representer for a {GogoKit::Page} of {GogoKit::SearchResult}s
  module SearchResultsRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: SearchResult,
               extend: SearchResultRepresenter,
               embedded: true
  end
end
