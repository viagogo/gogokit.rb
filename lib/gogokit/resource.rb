require 'roar/decorator'
require 'roar/json'
require 'roar/json/hal'

module GogoKit
  # Base class for resources returned in API responses
  class Resource
    attr_accessor :links
  end

  # A {Representable::Decorator} for {GogoKit::Resource}
  class ResourceRepresenter < Roar::Decorator
    include Roar::Hypermedia
    include Roar::JSON
    include Roar::JSON::HAL
    include Roar::Decorator::HypermediaConsumer

    link(:self) { 'http://self' }
  end
end
