require 'ostruct'
require 'representable/json'

module GogoKit
  # Represents the seating information for a ticket(s) in a Venue
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#seating
  class Seating < OpenStruct
  end

  module SeatingRepresenter
    include Representable::JSON

    property :section
    property :row
    property :seat_from
    property :seat_to
  end
end
