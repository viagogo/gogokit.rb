require 'ostruct'
require 'representable/json'
require 'gogokit/row'

module GogoKit
  class Section < OpenStruct
  end

  module SectionRepresenter
    include Representable::JSON

    property :name
    property :free_text_row
    collection :rows,
               class: GogoKit::Row,
               extend: GogoKit::RowRepresenter,
               skip_parse: ->(fragment, _) { fragment.nil? }
  end
end
