require 'gogokit/utils'
require 'gogokit/resource/venue'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting venues
    module Venue
      include GogoKit::Utils

      # Retrieves a venue by ID
      #
      # @param [Integer] venue_id The ID of the venue to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::Venue] The requested venue
      def get_venue(venue_id, options = {})
        root = get_root
        object_from_response(GogoKit::Venue,
                             GogoKit::VenueRepresenter,
                             :get,
                             "#{root.links['self'].href}/venues/" \
                             "#{venue_id}",
                             options)
      end

      # Retrieves all venues
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#viagogovenues
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All venues
      def get_venues(options = {})
        object_from_response(GogoKit::PagedResource,
                             GogoKit::VenuesRepresenter,
                             :get,
                             get_root.links['viagogo:venues'].href,
                             options)
      end
    end
  end
end
