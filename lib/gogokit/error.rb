module GogoKit
  # Custom error class for rescuing from all GogoKit errors
  class Error < StandardError; end

  # Raised when {GogoKit::Client} is not configured correctly
  class ConfigurationError < Error; end
end
