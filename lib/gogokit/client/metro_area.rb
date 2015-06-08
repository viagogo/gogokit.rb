require 'gogokit/utils'
require 'gogokit/resource/metro_area'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting metro areas
    module MetroArea
      include GogoKit::Utils

      # Retrieves a metro area by ID
      #
      # @param [Integer] metro_area_id The ID of the metro area to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::MetroArea] The requested metro area
      def get_metro_area(metro_area_id, options = {})
        root = get_root
        object_from_response(GogoKit::MetroArea,
                             GogoKit::MetroAreaRepresenter,
                             :get,
                             "#{root.links['self'].href}/metro_areas/" \
                             "#{metro_area_id}",
                             options)
      end

      # Retrieves all metro_areas
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#viagogometro_areas
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All metro_areas
      def get_metro_areas(options = {})
        object_from_response(GogoKit::PagedResource,
                             GogoKit::MetroAreasRepresenter,
                             :get,
                             get_root.links['viagogo:metro_areas'].href,
                             options)
      end
    end
  end
end
