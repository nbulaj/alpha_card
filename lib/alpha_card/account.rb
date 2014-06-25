module AlphaCard
  class Account < AlphaCardObject
    attribute :username, String
    attribute :password, String

    def initialize(username, password)
      self.username = username
      self.password = password
    end

    def filled?
      [self.username, self.password].all?(&:present?)
    end
  end
end