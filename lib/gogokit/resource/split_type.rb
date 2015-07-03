require 'gogokit/resource'

module GogoKit
  # @see http://viagogo.github.io/developer.viagogo.net/#splittype
  class SplitType < Resource
    attr_accessor :type,
                  :name,
                  :description
  end

  module SplitTypeRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :type
    property :name
    property :description
  end
end
