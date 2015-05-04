require 'roar/json'
require 'roar/json/hal'
require 'gogokit/resource'

module GogoKit
  # Base class for pages of resources returned in API responses
  class PagedResource < Resource
    attr_accessor :page,
                  :page_size,
                  :total_items,
                  :items
  end

  # Representer for {GogoKit::PagedResource}s
  module PagedResourceRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :page
    property :page_size
    property :total_items
  end
end
