require 'gogokit/resource'
require 'gogokit/resource/country'

module GogoKit
  # A location where an event takes place.
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#venue
  class Venue < Resource
    attr_accessor :id,
                  :name,
                  :address_1,
                  :address_2,
                  :city,
                  :state_province,
                  :postal_code,
                  :latitude,
                  :longitude,
                  :country
  end

  module VenueRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :name
    property :address_1
    property :address_2
    property :city
    property :state_province
    property :postal_code
    property :latitude
    property :longitude
    property :country,
             class: Country,
             extend: CountryRepresenter,
             embedded: true
  end

  module VenuesRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: Venue,
               extend: VenueRepresenter,
               embedded: true
  end
end
