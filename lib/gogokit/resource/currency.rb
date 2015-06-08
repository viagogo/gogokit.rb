require 'gogokit/resource'

module GogoKit
  # @see http://viagogo.github.io/developer.viagogo.net/#currency
  class Currency < Resource
    attr_accessor :code,
                  :name
  end

  module CurrencyRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :code
    property :name
  end

  module CurrenciesRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: Currency,
               extend: CurrencyRepresenter,
               embedded: true
  end
end
