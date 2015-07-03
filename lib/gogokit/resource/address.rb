require 'gogokit/resource'
require 'gogokit/paged_resource'
require 'gogokit/resource/country'

module GogoKit
  # @see http://developer.viagogo.net/#address
  class Address < Resource
    attr_accessor :id,
                  :full_name,
                  :address_1,
                  :address_2,
                  :address_3,
                  :city,
                  :state_province,
                  :postal_code,
                  :latitude,
                  :longitude,
                  :country
  end

  module AddressRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :full_name
    property :address_1
    property :address_2
    property :address_3
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

  module AddressesRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: Address,
               extend: AddressRepresenter,
               embedded: true
  end
end
