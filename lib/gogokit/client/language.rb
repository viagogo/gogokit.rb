require 'gogokit/utils'
require 'gogokit/resource/language'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting languages
    module Language
      include GogoKit::Utils

      # Retrieves a language by language code
      #
      # @param [String] code The language code of the language to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::Country] The requested language
      def get_language(code, options = {})
        root = get_root
        object_from_response(GogoKit::Language,
                             GogoKit::LanguageRepresenter,
                             :get,
                             "#{root.links['self'].href}/languages/#{code}",
                             options)
      end

      # Retrieves all languages supported by viagogo
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#viagogolanguages
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All languages
      def get_languages(options = {})
        object_from_response(GogoKit::PagedResource,
                             GogoKit::LanguagesRepresenter,
                             :get,
                             get_root.links['viagogo:languages'].href,
                             options)
      end
    end
  end
end
