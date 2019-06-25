# frozen_string_literal: true

# typed: true
module AlphaCard
  ##
  # AlphaCard gem version.
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  ##
  # AlphaCard semantic versioning
  module VERSION
    # Major version number
    MAJOR = 0
    # Minor version number
    MINOR = 5
    # Smallest version number
    TINY = 0

    # Full version number
    STRING = [MAJOR, MINOR, TINY].compact.join('.')
  end
end
