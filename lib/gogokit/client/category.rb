require 'gogokit/utils'
require 'gogokit/resource/category'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting categories
    module Category
      include GogoKit::Utils

      # Retrieves a category by ID
      #
      # @param [Integer] category_id The ID of the category to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::Category] The requested category
      def get_category(category_id, options = {})
        root = get_root
        object_from_response(GogoKit::Category,
                             GogoKit::CategoryRepresenter,
                             :get,
                             "#{root.links['self'].href}/categories/" \
                             "#{category_id}",
                             options)
      end

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
