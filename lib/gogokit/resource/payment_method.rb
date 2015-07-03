require 'gogokit/resource'
require 'gogokit/resource/address'

module GogoKit
  # @see http://developer.viagogo.net/#paymentmethod
  class PaymentMethod < Resource
    attr_accessor :id,
                  :details,
                  :type,
                  :type_description,
                  :buyer_method,
                  :default_buyer_method,
                  :seller_method,
                  :default_seller_method,
                  :billing_address
  end

  module PaymentMethodRepresenter
    include Representable::JSON
    include GogoKit::ResourceRepresenter

    property :id
    property :details
    property :type
    property :type_description
    property :buyer_method
    property :default_buyer_method
    property :seller_method
    property :default_seller_method
    property :billing_address,
             class: Address,
             extend: AddressRepresenter,
             embedded: true
  end

  module PaymentMethodsRepresenter
    include Representable::JSON
    include GogoKit::PagedResourceRepresenter

    collection :items,
               class: PaymentMethod,
               extend: PaymentMethodRepresenter,
               embedded: true
  end
end
