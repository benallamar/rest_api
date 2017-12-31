require "jsonclient"

require "rest_api/version"
require "rest_api/component"

module RESTAPI
  class Config
    attr_accessor :uri, :username, :passowrd, :use_tls
    def initialize
      @use_tls = false
    end
  end
  class EndPointAPI < JSONClient
    attr_accessor uri

    def initialize(uri)
      @config = Config.new
      if block_given?
        yield self.config
      end
      super.initialize(uri)
    end

    def component(name)
      ::Component.new(self, name)
    end
  end
end