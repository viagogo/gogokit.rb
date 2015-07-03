require 'gogokit/utils'
require 'gogokit/resource/address'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting addresses for the authenticated user
    module Address
      include GogoKit::Utils

      # Retrieves all addresses for the authenticated user
      #
      # @see http://developer.viagogo.net/#useraddresses
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All addresses for the authenticated
      # user
      def get_addresses(options = {})
        root = get_root
        object_from_response(GogoKit::PagedResource,
                             GogoKit::AddressesRepresenter,
                             :get,
                             "#{root.links['self'].href}/addresses",
                             options)
      end
    end
  end
end
