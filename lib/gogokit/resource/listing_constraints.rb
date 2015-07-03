require 'gogokit/resource'
require 'gogokit/resource/currency'
require 'gogokit/resource/listing_note'
require 'gogokit/resource/split_type'
require 'gogokit/resource/ticket_type'
require 'gogokit/section'

module GogoKit
  # @see http://viagogo.github.io/developer.viagogo.net/#listingconstraint
  class ListingConstraints < Resource
    attr_accessor :min_ticket_price,
                  :max_ticket_price,
                  :min_number_of_tickets,
                  :max_number_of_tickets,
                  :ticket_location_required,
                  :seats_required,
                  :sections,
                  :ticket_types,
                  :split_types,
                  :listing_notes,
                  :currencies
  end

  module ListingConstraintsRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :min_ticket_price,
             class: GogoKit::Money,
             extend: GogoKit::MoneyRepresenter,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :max_ticket_price,
             class: GogoKit::Money,
             extend: GogoKit::MoneyRepresenter,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :min_number_of_tickets
    property :max_number_of_tickets
    property :ticket_location_required
    property :seats_required
    collection :sections,
               class: GogoKit::Section,
               extend: GogoKit::SectionRepresenter,
               skip_parse: ->(fragment, _) { fragment.nil? }
    collection :ticket_types,
               class: GogoKit::TicketType,
               extend: GogoKit::TicketTypeRepresenter,
               skip_parse: ->(fragment, _) { fragment.nil? },
               embedded: true
    collection :split_types,
               class: GogoKit::SplitType,
               extend: GogoKit::SplitTypeRepresenter,
               skip_parse: ->(fragment, _) { fragment.nil? },
               embedded: true
    collection :listing_notes,
               class: GogoKit::ListingNote,
               extend: GogoKit::ListingNoteRepresenter,
               skip_parse: ->(fragment, _) { fragment.nil? },
               embedded: true
    collection :currencies,
               class: GogoKit::Currency,
               extend: GogoKit::CurrencyRepresenter,
               skip_parse: ->(fragment, _) { fragment.nil? },
               embedded: true
  end
end
