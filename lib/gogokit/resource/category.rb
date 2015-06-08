require 'gogokit/resource'
require 'gogokit/paged_resource'
require 'gogokit/money'
require 'roar/coercion'

module GogoKit
  # Represents a grouping of events or other categories
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#category
  class Category < Resource
    attr_accessor :id,
                  :name,
                  :description_html,
                  :min_ticket_price,
                  :min_event_date,
                  :max_event_date
  end

  module CategoryRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :name
    property :description_html
    property :min_ticket_price,
             extend: GogoKit::MoneyRepresenter,
             class: GogoKit::Money,
             skip_parse: ->(fragment, _) { fragment.nil? }
    property :min_event_date, type: DateTime
    property :max_event_date, type: DateTime
  end

  module CategoriesRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: Category,
               extend: CategoryRepresenter,
               embedded: true
  end
end
