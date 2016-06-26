class LoginController < ApplicationController
  REDIRECT_URI = 'YOUR_REDIRECT_URI'.freeze
  SCOPES = %w(read:sellerlistings write:sellerlistings).freeze

  def initialize
    @client = GogoKit::Client.new do |config|
      config.client_id = YOUR_CLIENT_ID
      config.client_secret = YOUR_CLIENT_SECRET
      config.api_environment = :sandbox
    end
  end

  def index
    authorization_url = @client.get_authorization_url REDIRECT_URI, SCOPES, 'XY'
    redirect_to authorization_url
  end

  def oauth_callback
    code = params['code']
    token = @client.get_authorization_code_access_token code, REDIRECT_URI, SCOPES

    render :json => token
  end
end
