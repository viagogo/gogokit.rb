require 'gogokit/utils'
require 'gogokit/resource/search_result'

module GogoKit
  class Client
    # {GogoKit::Client} methods for searching for viagogo entities
    module Search
      include GogoKit::Utils

      # Search for entities that match a given query
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#viagogosearch
      # @param [String] query The query text to be used to match entities
      # @param [Hash] options Optional options
      # @return [GogoKit::Resource::PagedResource] The results of the query
      def search(query, options = {})
        options[:params] ||= {}
        options[:params] = options[:params].merge(query: query)
        object_from_response(GogoKit::PagedResource,
                             GogoKit::SearchResultsRepresenter,
                             :get,
                             get_root.links['viagogo:search'].href,
                             options)
      end
    end
  end
end
