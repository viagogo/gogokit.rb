require 'gogokit/utils'
require 'gogokit/resource/currency'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting currencies
    module Currency
      include GogoKit::Utils

      # Retrieves a currency by currency code
      #
      # @param [String] code The currency code of the currency to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::Country] The requested currency
      def get_currency(code, options = {})
        root = get_root
        object_from_response(GogoKit::Currency,
                             GogoKit::CurrencyRepresenter,
                             :get,
                             "#{root.links['self'].href}/currencies/#{code}",
                             options)
      end

      # Retrieves all currencies supported by viagogo
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#viagogocurrencies
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All currencies
      def get_currencies(options = {})
        object_from_response(GogoKit::PagedResource,
                             GogoKit::CurrenciesRepresenter,
                             :get,
                             get_root.links['viagogo:currencies'].href,
                             options)
      end
    end
  end
end
