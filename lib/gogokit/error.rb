module GogoKit
  # Custom error class for rescuing from all GogoKit errors
  class Error < StandardError; end

  # Raised when {GogoKit::Client} is not configured correctly
  class ConfigurationError < Error; end

  # Raised for any error returned by the API
  class ApiError < Error
    attr_accessor :response
  end
end
