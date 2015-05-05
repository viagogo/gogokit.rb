require 'gogokit/resource'
require 'gogokit/resource/country'

module GogoKit
  # A location where an event takes place.
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#country
  class Venue < Resource
    attr_accessor :id,
                  :name,
                  :city,
                  :latitude,
                  :longitude,
                  :country
  end

  module VenueRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :name
    property :city
    property :latitude
    property :longitude
    property :country,
             class: Country,
             extend: CountryRepresenter,
             embedded: true
  end
end
