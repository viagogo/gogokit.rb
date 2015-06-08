require 'gogokit/utils'
require 'gogokit/resource/listing'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting listings
    module Listing
      include GogoKit::Utils

      # Retrieves a listing by ID
      #
      # @param [Integer] listing_id The ID of the listing to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::Listing] The requested listing
      def get_listing(listing_id, options = {})
        root = get_root
        object_from_response(GogoKit::Listing,
                             GogoKit::ListingRepresenter,
                             :get,
                             "#{root.links['self'].href}/listings/" \
                             "#{listing_id}",
                             options)
      end

      # Retrieves all listings in a particular event
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#eventlistings
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All listings in the specified event
      def get_listings_by_event(event_id, options = {})
        root = get_root
        object_from_response(GogoKit::PagedResource,
                             GogoKit::ListingsRepresenter,
                             :get,
                             "#{root.links['self'].href}/events/" \
                             "#{event_id}/listings",
                             options)
      end
    end
  end
end
