require 'gogokit/resource'
require 'gogokit/resource/listing_note'
require 'gogokit/resource/ticket_type'
require 'gogokit/money'
require 'gogokit/seating'

module GogoKit
  # A set of tickets for sale on the viagogo marketplace
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#listing
  class Listing < Resource
    attr_accessor :id,
                  :number_of_tickets,
                  :seating,
                  :pickup_available,
                  :download_available,
                  :ticket_price,
                  :estimated_ticket_price,
                  :estimated_total_ticket_price,
                  :estimated_booking_fee,
                  :estimated_shipping,
                  :estimated_vat,
                  :estimated_total_charge,
                  :ticket_type,
                  :listing_notes
  end

  module ListingRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :number_of_tickets
    property :seating,
             extend: GogoKit::SeatingRepresenter,
             class: GogoKit::Seating,
             skip_parse: -> (fragment, _) { fragment.nil? }
    property :pickup_available
    property :download_available
    property :ticket_price,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: -> (fragment, _) { fragment.nil? }
    property :estimated_ticket_price,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: -> (fragment, _) { fragment.nil? }
    property :estimated_total_ticket_price,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: -> (fragment, _) { fragment.nil? }
    property :estimated_booking_fee,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: -> (fragment, _) { fragment.nil? }
    property :estimated_shipping,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: -> (fragment, _) { fragment.nil? }
    property :estimated_vat,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: -> (fragment, _) { fragment.nil? }
    property :estimated_total_charge,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: -> (fragment, _) { fragment.nil? }
    property :ticket_type,
             extend: GogoKit::TicketTypeRepresenter,
             class: GogoKit::TicketType,
             skip_parse: -> (fragment, _) { fragment.nil? },
             embedded: true
    collection :listing_notes,
               extend: GogoKit::ListingNoteRepresenter,
               class: GogoKit::ListingNote,
               skip_parse: -> (fragment, _) { fragment.nil? },
               embedded: true
  end

  module ListingsRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: Listing,
               extend: ListingRepresenter,
               embedded: true
  end
end
