require 'gogokit/resource'
require 'gogokit/paged_resource'
require 'gogokit/money'
require 'gogokit/resource/venue'
require 'roar/coercion'

module GogoKit
  # An event on the viagogo platform.
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#event
  class Event < Resource
    attr_accessor :id,
                  :name,
                  :start_date,
                  :end_date,
                  :date_confirmed,
                  :min_ticket_price,
                  :notes_html,
                  :restrictions_html,
                  :venue
  end

  module EventRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :name
    property :start_date, type: DateTime
    property :end_date, type: DateTime
    property :date_confirmed
    property :min_ticket_price,
             class: GogoKit::Money,
             extend: GogoKit::MoneyRepresenter,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :notes_html
    property :restrictions_html
    property :venue,
             class: Venue,
             extend: VenueRepresenter,
             skip_parse: ->(fragment, _) { fragment.nil? },
             embedded: true
  end

  module EventsRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: Event,
               extend: EventRepresenter,
               embedded: true
  end
end
