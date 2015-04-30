require 'faraday'

module GogoKit
  # HTTP Connection methods for {GogoKit::Client}
  module Connection
    private

    def connection_options  # rubocop:disable Metrics/MethodLength
      @connection_options ||= {
        headers: {
          accept: 'application/hal+json',
          content_type: 'application/hal+json',
          user_agent: user_agent
        },
        request: {
          open_timeout: 5,
          timeout: 10
        }
      }
    end

    def connection
      Faraday::Connection.new(nil, connection_options) do |builder|
        builder.use Faraday::Request::UrlEncoded

        builder.adapter Faraday.default_adapter
      end
    end
  end
end
