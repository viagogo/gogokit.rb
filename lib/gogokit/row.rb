require 'ostruct'
require 'representable/json'

module GogoKit
  class Row < OpenStruct
  end

  module RowRepresenter
    include Representable::JSON

    property :name
  end
end
