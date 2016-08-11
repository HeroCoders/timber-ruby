require "timber/contexts/rack_request/params"

module Timber
  module Contexts
    class RackRequest < HTTPRequest
      class Headers
        attr_reader :request

        def initialize(request)
          @request = request
        end

        def connect_time_ms
          @connect_time_ms ||= env["HTTP_CONNECT_TIME"]
        end

        def content_type
          @content_type ||= request.content_type
        end

        def referrer
          @referrer ||= request.referrer
        end

        def remote_addr
          @remote_addr ||= request.ip
        end

        def request_id
          return @request_id if defined?(@request_id)
          found = env.find do |k,v|
            # Needs to support:
            # action_dispatch.request_id
            # HTTP_X_REQUEST_ID
            # Request-ID
            # Request-Id
            # X-Request-ID
            # X-Request-Id
            # etc
            (k.downcase.include?("request_id") || k.downcase.include?("request-id")) && !v.nil?
          end
          @request_id = found && found.last
        end

        def user_agent
          @user_agent ||= request.user_agent
        end

        def as_json(*args)
          @as_json ||= {
            :connect_time_ms => connect_time_ms,
            :content_type => content_type,
            :referrer => referrer,
            :remote_addr => remote_addr,
            :request_id => request_id,
            :user_agent => user_agent
          }
        end

        def to_json(*args)
          # Note: this is run in the background thread, hence the hash creation.
          @to_json ||= as_json.to_json(*args)
        end
      end

      attr_reader :env

      def initialize(env)
        # Initialize should be as fast as possible since it is executed inline.
        # Hence the lazy methods below.
        @env = env
        super()
      end

      def headers
        @headers ||= Headers.new(request)
      end

      def host
        @host ||= request.host
      end

      def method
        @method ||= request.request_method.upcase
      end

      def path
        @path ||= request.path
      end

      def port
        @port ||= request.port
      end

      def query_params
        @query_params ||= request.params && Params.new(request.params)
      end

      def scheme
        @scheme ||= request.scheme
      end

      private
        def request
          @request ||= ::Rack::Request.new(env)
        end
    end
  end
end
