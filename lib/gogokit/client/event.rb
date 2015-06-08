require 'gogokit/utils'
require 'gogokit/resource/event'

module GogoKit
  class Client
    # {GogoKit::Client} methods for getting events
    module Event
      include GogoKit::Utils

      # Retrieves a event by ID
      #
      # @param [Integer] event_id The ID of the event to be retrieved
      # @param [Hash] options Optional options
      # @return [GogoKit::Event] The requested event
      def get_event(event_id, options = {})
        root = get_root
        object_from_response(GogoKit::Event,
                             GogoKit::EventRepresenter,
                             :get,
                             "#{root.links['self'].href}/events/" \
                             "#{event_id}",
                             options)
      end

      # Retrieves all events in a particular category
      #
      # @see http://viagogo.github.io/developer.viagogo.net/#categoryevents
      # @param [Hash] options Optional options
      # @return [GogoKit::PagedResource] All events in the specified category
      def get_events_by_category(category_id, options = {})
        root = get_root
        object_from_response(GogoKit::PagedResource,
                             GogoKit::EventsRepresenter,
                             :get,
                             "#{root.links['self'].href}/categories/" \
                             "#{category_id}/events",
                             options)
      end
    end
  end
end
