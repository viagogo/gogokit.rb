require 'gogokit/utils'
require 'gogokit/resource/listing_constraints'
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
        object_from_response(GogoKit::SellerListing,
                             GogoKit::SellerListingRepresenter,
                             :get,
                             "#{api_root_endpoint}/sellerlistings/" \
                             "#{listing_id}",
                             options)
      end

      # Retrieves all listings for the authenticated user
      #
      # @see http://developer.viagogo.net/#usersellerlistings
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All listings for the authenticated user
      def get_seller_listings(options = {})
        object_from_response(GogoKit::PagedResource,
                             GogoKit::SellerListingsRepresenter,
                             :get,
                             "#{api_root_endpoint}/sellerlistings",
                             options)
      end

      # Retrieves the constraints for creating a listing for an event
      #
      # @param [Integer] event_id The ID of the event
      # @param [Hash] options Optional options
      # @return [GogoKit::ListingConstraints] The constraints for creating a
      # listing for an event
      def get_listing_constraints_for_event(event_id, options = {})
        object_from_response(GogoKit::ListingConstraints,
                             GogoKit::ListingConstraintsRepresenter,
                             :get,
                             "#{api_root_endpoint}/events/#{event_id}" \
                             '/listingconstraints',
                             options)
      end

      # Retrieves the constraints for updating a listing
      #
      # @param [Integer] listing_id The ID of the listing
      # @param [Hash] options Optional options
      # @return [GogoKit::ListingConstraints] The constraints for updating a
      # listing
      def get_listing_constraints(listing_id, options = {})
        object_from_response(GogoKit::ListingConstraints,
                             GogoKit::ListingConstraintsRepresenter,
                             :get,
                             "#{api_root_endpoint}/sellerlistings/" \
                             "#{listing_id}/constraints",
                             options)
      end

      # Creates a preview of a listing for an event
      #
      # @param [Integer] event_id The ID of the event
      # @param [Hash] options Optional options
      # @return [GogoKit::SellerListing] The preview of a listing for an event
      def create_seller_listing_preview(event_id, options = {})
        object_from_response(GogoKit::SellerListing,
                             GogoKit::SellerListingRepresenter,
                             :post,
                             "#{api_root_endpoint}/events/" \
                             "#{event_id}/sellerlistingpreview",
                             options)
      end

      # Creates a preview of an update to a listing
      #
      # @param [Integer] listing_id The ID of the listing
      # @param [Hash] options Optional options
      # @return [GogoKit::SellerListing] The preview of a listing for an event
      def create_seller_listing_update_preview(listing_id, options = {})
        object_from_response(GogoKit::SellerListing,
                             GogoKit::SellerListingRepresenter,
                             :post,
                             "#{api_root_endpoint}/sellerlistings/" \
                             "#{listing_id}/updatepreview",
                             options)
      end

      # Creates a listing for an event
      #
      # @param [Integer] event_id The ID of the event
      # @param [Hash] options Optional options
      # @return [GogoKit::SellerListing] The newly created listing
      def create_seller_listing(event_id, options = {})
        object_from_response(GogoKit::SellerListing,
                             GogoKit::SellerListingRepresenter,
                             :post,
                             "#{api_root_endpoint}/events/" \
                             "#{event_id}/sellerlistings",
                             options)
      end

      # Updates an existing listing
      #
      # @param [Integer] listing_id The ID of the listing
      # @param [Hash] options Optional options
      # @return [GogoKit::SellerListing] The updated created listing
      def update_seller_listing(listing_id, options = {})
        object_from_response(GogoKit::SellerListing,
                             GogoKit::SellerListingRepresenter,
                             :patch,
                             "#{api_root_endpoint}/sellerlistings/" \
                             "#{listing_id}",
                             options)
      end

      # Deletes a listing
      #
      # @param [Integer] listing_id The ID of the listing
      # @param [Hash] options Optional options
      # @return [Hash] object containing response information
      def delete_seller_listing(listing_id, options = {})
        delete("#{api_root_endpoint}/sellerlistings/#{listing_id}",
               options)
      end
    end
  end
end
