require 'faraday'
require 'gogokit/error'

module GogoKit
  module Middleware
    class RaiseError < Faraday::Middleware
      def initialize(app)
        super app
      end

      def call(request_env)
        @app.call(request_env).on_complete do |response_env|
          if response_env[:status].to_i >= 400
            api_error = GogoKit::ApiError.new
            api_error.response = response_env
            raise api_error, error_message(response_env)
          end
        end
      end

      def error_message(response_env)
        "#{response_env[:method].to_s.upcase} #{response_env[:url]}:" \
        " #{response_env[:status]}}"
      end
    end
  end
end
