require 'gogokit/resource'
require 'gogokit/paged_resource'
require 'gogokit/resource/category'
require 'gogokit/resource/event'
require 'gogokit/resource/metro_area'
require 'gogokit/resource/venue'

module GogoKit
  # A result of a search query
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#searchresult
  class SearchResult < Resource
    attr_accessor :title,
                  :type,
                  :type_description,
                  :event,
                  :category,
                  :metro_area,
                  :venue
  end

  # Representer for {GogoKit::SearchResult}
  module SearchResultRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :title
    property :type
    property :type_description
    property :event, class: Event, extend: EventRepresenter, embedded: true
    property :category,
             class: Category,
             extend: CategoryRepresenter,
             embedded: true
    property :metro_area,
             class: MetroArea,
             extend: MetroAreaRepresenter,
             embedded: true
    property :venue, class: Venue, extend: VenueRepresenter, embedded: true
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
