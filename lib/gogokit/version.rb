module GogoKit
  # Current major release.
  # @return [Integer]
  MAJOR = 0

  # Current minor release.
  # @return [Integer]
  MINOR = 4

  # Current patch level.
  # @return [Integer]
  PATCH = 1

  # Full release version.
  # @return [String]
  VERSION = [MAJOR, MINOR, PATCH].join('.')
end
