require 'gogokit/resource'

module GogoKit
  # The root of the viagogo API service.
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#root
  class Root < Resource
  end

  # A representer for {GogoKit::Root}
  module RootRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter
  end
end
