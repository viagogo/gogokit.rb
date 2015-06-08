require 'gogokit/utils'
require 'gogokit/resource/country'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting countries
    module Country
      include GogoKit::Utils

      # Retrieves a country by country code
      #
      # @param [String] code The country code of the country to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::Country] The requested country
      def get_country(code, options = {})
        root = get_root
        object_from_response(GogoKit::Country,
                             GogoKit::CountryRepresenter,
                             :get,
                             "#{root.links['self'].href}/countries/#{code}",
                             options)
      end

      # Retrieves all countries
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#viagogocountries
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All countries
      def get_countries(options = {})
        object_from_response(GogoKit::PagedResource,
                             GogoKit::CountriesRepresenter,
                             :get,
                             get_root.links['viagogo:countries'].href,
                             options)
      end
    end
  end
end
