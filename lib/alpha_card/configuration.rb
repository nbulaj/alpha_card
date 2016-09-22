module AlphaCard
  # AlphaCard configuration class for global credentials settings
  class Configuration
    attr_accessor :username, :password

    def self.use_demo_credentials!
      self.username = 'demo'
      self.password = 'password'
    end
  end
end
