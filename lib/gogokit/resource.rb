require 'roar/json'
require 'roar/json/hal'

module GogoKit
  # Base class for resources returned in API responses
  class Resource
    attr_accessor :links
  end

  # A base representer module for every {GogoKit::Resource}
  module ResourceRepresenter
    include Roar::Hypermedia
    include Roar::JSON
    include Roar::JSON::HAL

    link(:self) { 'http://self' }
  end
end
