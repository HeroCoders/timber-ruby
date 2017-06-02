module Timber
  class CLI
    class API
      class Application
        DEVELOPMENT = "development".freeze
        HEROKU = "heroku".freeze

        attr_accessor :api_key, :environment, :framework_type, :heroku_drain_url,
          :name, :platform_type

        def initialize(attributes)
          @api_key = attributes.fetch("api_key")
          @environment = attributes.fetch("environment")
          @framework_type = attributes.fetch("framework_type")
          @heroku_drain_url = attributes.fetch("heroku_drain_url")
          @name = attributes.fetch("name")
          @platform_type = attributes.fetch("platform_type")
        end

        def development?
          environment == DEVELOPMENT
        end

        def heroku?
          platform_type == HEROKU
        end
      end
    end
  end
end