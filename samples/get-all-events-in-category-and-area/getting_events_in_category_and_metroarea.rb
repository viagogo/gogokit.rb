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

# 1. Find the category we care about (in this case, it's the "Concerts" genre).
# see http://developer.viagogo.net/#entities
genres = client.get_genres
category = genres.items.select { |c| c.name.include? 'Concert' }[0]
puts "Found a Category named #{category.name}."

# 2. Find the MetroArea we care about (in this case, it's "Buenos Aires")
puts "Searching for the MetroArea for 'Buenos Aires'"
search_results = client.search 'Buenos Aires', params: {'type' => 'MetroArea'}
metro_area_link = search_results.items[0].links['searchresult:metroarea'].href
metro_area = client.object_from_response(GogoKit::MetroArea,
                                         GogoKit::MetroAreaRepresenter,
                                         :get,
                                         metro_area_link,
                                         nil)
puts "Found a MetroArea for named #{metro_area.name} with ID #{metro_area.id}"

# 3. Use the MetroArea ID to filter the events in the Category.
# See http://developer.viagogo.net/#categoryevents
page_of_events = client.get_events_by_category(
  category.id,
  params: {'metro_area_id' => "#{metro_area.id}"})

puts "There are #{page_of_events.total_items} #{category.name} events in " \
     "#{metro_area.name}"
