require 'gogokit'

# All methods require OAuth2 authentication. To get OAuth2 credentials for your
# application, see http://developer.viagogo.net/#authentication.
client = GogoKit::Client.new do |config|
  config.client_id = YOUR_CLIENT_ID
  config.client_secret = YOUR_CLIENT_SECRET
end

# Get an access token. See http://developer.viagogo.net/#getting-access-tokens
token = client.get_client_access_token
client.access_token = token.access_token

# 1. Request resource sorted by `resource_version`
page_of_events = client.get_events_by_category(
  CATEGORY_ID,
  params: {
    'sort' => 'resource_version',
    'page_size' => 1000
  })
puts "Retrieved #{page_of_events.items.size} of #{page_of_events.total_items}" \
     ' events sorted by when they were last updated'

# 2. Follow the `next` link to get events that have changed since your last
# request
next_link = page_of_events.links['next']
until next_link.nil?
  puts "Following next link '#{next_link.href}' to get updated events"
  next_link_to_store_in_db = next_link
  page_of_events = client.object_from_response(GogoKit::PagedResource,
                                               GogoKit::EventsRepresenter,
                                               :get,
                                               next_link.href,
                                               nil)
  puts "Retrieved #{page_of_events.items.size} of " \
       "#{page_of_events.total_items} events sorted by when they were last " \
       'updated'
  next_link = page_of_events.links['next']
end

# 3. After retrieving all changes, store the previous `next` link in your
# database until the next time you want to get updates
puts "Store '#{next_link_to_store_in_db.href}' link until the next time you " \
     'want to get changed events'
