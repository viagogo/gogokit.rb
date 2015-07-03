require 'gogokit'
require 'json'

# All methods require OAuth2 authentication. To get OAuth2 credentials for your
# application, see http://developer.viagogo.net/#authentication.
client = GogoKit::Client.new do |config|
  config.client_id = YOUR_CLIENT_ID
  config.client_secret = YOUR_CLIENT_SECRET

  # Note: To create listings you need an access token with the following scopes:
  # 'read:user', 'read:sellerlistings', 'write:sellerlistings'
  # see http://developer.viagogo.net/?ruby#scopes
  config.access_token = ACCESS_TOKEN
end

# 1. Find the event that you want to list tickets for
event = client.get_event EVENT_ID

# 2. Get the constraints for listings on that event
puts "Getting constraints for Event #{event.id} - #{event.name}"
constraints = client.get_listing_constraints_for_event event.id
puts "Retrieved listing constraints for Event #{event.id}:\n" \
     "Min Ticket Price: #{constraints.min_ticket_price.amount}"

# 3. Create the listing with values that meet the constraints
puts "Creating listing for Event #{event.id} - #{event.name}"
json = {
  number_of_tickets: NUMBER_OF_TICKETS,
  seating: {
    section: SECTION,
    row: ROW,
    seat_from: SEAT_FROM,
    seat_to: SEAT_TO
  },
  ticket_price: {
    amount: PRICE,
    currency_code: CURRENCY_CODE
  },
  face_value: {
    amount: FACE_VALUE,
    currency_code: CURRENCY_CODE
  },
  ticket_type: TICKET_TYPE,
  split_type: SPLIT_TYPE,
  guarantee_payment_method_id: GUARANTEE_PAYMENT_METHOD_ID,
  ticket_location_address_id: TICKET_LOCATION_ADDRESS_ID
}.to_json
seller_listing = client.create_seller_listing(EVENT_ID, body: json)

puts "Successfully created listing #{seller_listing.id}"
