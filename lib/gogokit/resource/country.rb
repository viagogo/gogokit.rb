require 'gogokit/resource'
require 'gogokit/paged_resource'
require 'gogokit/resource/country'

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

  module CountriesRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: Country,
               extend: CountryRepresenter,
               embedded: true
  end
end
