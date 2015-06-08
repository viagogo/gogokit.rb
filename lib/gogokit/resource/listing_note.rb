require 'gogokit/resource'

module GogoKit
  # @see http://viagogo.github.io/developer.viagogo.net/#listingnote
  class ListingNote < Resource
    attr_accessor :id,
                  :note
  end

  module ListingNoteRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :note
  end
end
