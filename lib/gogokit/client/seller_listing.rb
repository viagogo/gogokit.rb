require 'gogokit/utils'
require 'gogokit/resource/seller_listing'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting seller_listings
    module SellerListing
      include GogoKit::Utils

      # Retrieves a listing by ID
      #
      # @param [Integer] listing_id The ID of the listing to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::SellerListing] The requested listing
      def get_seller_listing(listing_id, options = {})
        root = get_root
        object_from_response(GogoKit::SellerListing,
                             GogoKit::SellerListingRepresenter,
                             :get,
                             "#{root.links['self'].href}/sellerlistings/" \
                             "#{listing_id}",
                             options)
      end

      # Retrieves all listings for the authenticated user
      #
      # @see http://developer.viagogo.net/#usersellerlistings
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All listings for the authenticated user
      def get_seller_listings(options = {})
        root = get_root
        object_from_response(GogoKit::PagedResource,
                             GogoKit::SellerListingsRepresenter,
                             :get,
                             "#{root.links['self'].href}/sellerlistings",
                             options)
      end
    end
  end
end
