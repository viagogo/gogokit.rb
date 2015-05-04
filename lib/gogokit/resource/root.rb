require 'gogokit/resource'

module GogoKit
  # The root of the viagogo API service.
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#root
  class Root < Resource
  end

  # A {Representable::Decorator} for {GogoKit::Root}
  class RootRepresenter < ResourceRepresenter
  end
end
