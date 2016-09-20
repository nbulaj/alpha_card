module AlphaCard
  ##
  # Exception class for invalid Alpha Card objects.
  # Raises when some of the object doesn't have all
  # the necessary attributes.
  class InvalidObjectError < StandardError
  end
end
