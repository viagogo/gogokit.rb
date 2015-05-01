require 'ostruct'
require 'roar/decorator'
require 'roar/json/hal'

module GogoKit
  # Resources returned in API responses
  module Resource
    # The root of the viagogo API service.
    #
    # @see http://viagogo.github.io/developer.viagogo.net/#root
    class Root < OpenStruct
    end

    # A {Representable::Decorator} for {GogoKit::Root}
    class RootRepresenter < Roar::Decorator
      include Roar::JSON::HAL
    end
  end
end
