require 'gogokit/resource'
require 'gogokit/resource/event'
require 'gogokit/resource/venue'
require 'gogokit/resource/listing_note'
require 'gogokit/resource/split_type'
require 'gogokit/resource/ticket_type'
require 'gogokit/money'
require 'gogokit/seating'
require 'roar/coercion'

module GogoKit
  # A set of tickets for sale on the viagogo marketplace
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#sellerlisting
  class SellerListing < Resource
    attr_accessor :id,
                  :external_id,
                  :created_at,
                  :updated_at,
                  :in_hand_at,
                  :number_of_tickets,
                  :display_number_of_tickets,
                  :seating,
                  :display_seating,
                  :face_value,
                  :ticket_price,
                  :ticket_proceeds,
                  :instant_delivery,
                  :event,
                  :venue,
                  :ticket_type,
                  :split_type,
                  :listing_notes
  end

  module SellerListingRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :external_id
    property :created_at, type: DateTime
    property :updated_at, type: DateTime
    property :in_hand_at, type: DateTime
    property :number_of_tickets
    property :display_number_of_tickets
    property :instant_delivery
    property :seating,
             extend: GogoKit::SeatingRepresenter,
             class: GogoKit::Seating,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :display_seating,
             extend: GogoKit::SeatingRepresenter,
             class: GogoKit::Seating,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :face_value,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :ticket_price,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :ticket_proceeds,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :event,
             class: Event,
             extend: EventRepresenter,
             skip_parse: ->(fragment, _) { fragment.nil? },
             embedded: true
    property :venue,
             class: Venue,
             extend: VenueRepresenter,
             skip_parse: ->(fragment, _) { fragment.nil? },
             embedded: true
    property :ticket_type,
             extend: GogoKit::TicketTypeRepresenter,
             class: GogoKit::TicketType,
             skip_parse: ->(fragment, _) { fragment.nil? },
             embedded: true
    property :split_type,
             extend: GogoKit::SplitTypeRepresenter,
             class: GogoKit::SplitType,
             skip_parse: ->(fragment, _) { fragment.nil? },
             embedded: true
    collection :listing_notes,
               extend: GogoKit::ListingNoteRepresenter,
               class: GogoKit::ListingNote,
               skip_parse: ->(fragment, _) { fragment.nil? },
               embedded: true
  end

  module SellerListingsRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: SellerListing,
               extend: SellerListingRepresenter,
               embedded: true
  end
end
