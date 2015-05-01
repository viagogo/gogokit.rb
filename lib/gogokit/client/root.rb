require 'gogokit/utils'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting the root resource
    module Root
      include GogoKit::Utils

      # Gets the root of the viagogo API service.
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#root-endpoint
      # @param [Hash] options Optional options
      # @return [GogoKit::Resource::Root] The root resource
      def get_root
        nil
      end
    end
  end
end
