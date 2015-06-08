require 'gogokit/resource'

module GogoKit
  # @see http://viagogo.github.io/developer.viagogo.net/#language
  class Language < Resource
    attr_accessor :code,
                  :name
  end

  module LanguageRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :code
    property :name
  end

  module LanguagesRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: Language,
               extend: LanguageRepresenter,
               embedded: true
  end
end
