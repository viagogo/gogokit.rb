require 'gogokit/utils'
require 'gogokit/resource/user'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting and updating the authenticated user
    module User
      include GogoKit::Utils

      # Retrieves account information for the authenticated user
      #
      # @param [Hash] options Optional options
      # @return [GogoKit::User] The authenticated user
      def get_user(options = {})
        object_from_response(GogoKit::User,
                             GogoKit::UserRepresenter,
                             :get,
                             get_root.links['viagogo:user'].href,
                             options)
      end
    end
  end
end
