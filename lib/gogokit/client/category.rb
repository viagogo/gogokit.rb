require 'gogokit/utils'
require 'gogokit/resource/category'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting categories
    module Category
      include GogoKit::Utils

      # Retrieves the genre categories (e.g. Sports, Concerts, Theatre)
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#viagogogenres
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] The genre categories
      def get_genres(options = {})
        object_from_response(GogoKit::PagedResource,
                             GogoKit::CategoriesRepresenter,
                             :get,
                             get_root.links['viagogo:genres'].href,
                             options)
      end
    end
  end
end
