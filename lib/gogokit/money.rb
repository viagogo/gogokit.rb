require 'ostruct'
require 'representable/json'

module GogoKit
  # Returned for monetary values, such as ticket prices, fees charged and tax
  # amounts.
  #
  # @see http://viagogo.github.io/developer.viagogo.net/#money
  class Money < OpenStruct
  end

  module MoneyRepresenter
    include Representable::JSON

    property :amount
    property :currency_code
    property :display
  end
end
