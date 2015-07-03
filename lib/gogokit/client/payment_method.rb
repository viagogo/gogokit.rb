require 'gogokit/utils'
require 'gogokit/resource/payment_method'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting payment methods for the
    # authenticated user
    module PaymentMethod
      include GogoKit::Utils

      # Retrieves all payment methods for the authenticated user
      #
      # @see http://developer.viagogo.net/#userpaymentmethods
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All payment methods for the
      # authenticated user
      def get_payment_methods(options = {})
        root = get_root
        object_from_response(GogoKit::PagedResource,
                             GogoKit::PaymentMethodsRepresenter,
                             :get,
                             "#{root.links['self'].href}/paymentmethods",
                             options)
      end
    end
  end
end
