require 'addressable/uri'
require 'yajl/json_gem'

require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'
require 'em-http/middleware/oauth'
require 'em-http/middleware/json_response'

module EM
  class Twitter
    attr_reader :config

    SEARCH_URI            = 'http://api.twitter.com/1.1/search/tweets.json'
    SEARCH_OPTIONS        = {include_entities: 'true', result_type: 'recent', count: 100}

    STREAM_URI            = 'https://stream.twitter.com/1.1/statuses/filter.json'
    STREAM_OPTIONS        = {}

    USER_URI              = 'http://api.twitter.com/1.1/users/show.json'
    USER_OPTIONS          = {}

    USER_TIMELINE_URI     = 'https://api.twitter.com/1.1/statuses/user_timeline.json'
    USER_TIMELINE_OPTIONS = {count: 200}

    def initialize config
      @config = config.dup
    end

    def config_hash hash
      Yajl.load(Yajl.dump(hash), symbolize_keys: true)
    end

    def search query
      uri   = Addressable::URI.parse(SEARCH_URI).tap {|u| u.query_values = SEARCH_OPTIONS.merge(q: query)}
      conn  = EM::HttpRequest.new(uri.to_s)

      conn.use EM::Middleware::JSONResponse
      conn.use EM::Middleware::OAuth, config
      http = conn.get
      parse_response(http)
    end

    def user_timeline user
      opts = USER_TIMELINE_OPTIONS.merge(screen_name: user.sub(/^@/, ''))
      uri  = Addressable::URI.parse(USER_TIMELINE_URI).tap {|u| u.query_values = opts}
      conn = EM::HttpRequest.new(uri.to_s)

      conn.use EM::Middleware::JSONResponse
      conn.use EM::Middleware::OAuth, config
      http = conn.get
      parse_response(http)
    end

    def stream options, &block
      uri  = Addressable::URI.parse(STREAM_URI).tap {|u| u.query_values = STREAM_OPTIONS.merge(options)}
      conn = EM::HttpRequest.new(uri.to_s, connect_timeout: 10, inactivity_timeout: 86400, ssl: {verify_peer: false})

      conn.use EM::Middleware::OAuth, config

      tokenizer = BufferedTokenizer.new
      http      = conn.apost(keepalive: true)

      http.stream do |chunk|
        tokenizer.extract(chunk).each do |data|
          begin
            block.call(Yajl.load(data))
          rescue => e
            puts "ERROR: #{data}", e.message, e.backtrace.take(10).join($/)
          end
        end
      end
    end

    def user options
      uri  = Addressable::URI.parse(USER_URI).tap {|u| u.query_values = USER_OPTIONS.merge(options)}
      conn = EM::HttpRequest.new(uri.to_s)

      conn.use EM::Middleware::JSONResponse
      conn.use EM::Middleware::OAuth, config
      http = conn.get
      parse_response(http)
    end

    class Error < StandardError
      attr_reader :code, :retry_after, :message

      def initialize params = {}
        @code    = params.fetch(:code)
        @message = params.fetch(:message, "Twitter error: #{code}")
        @retry   = params.fetch(:retry_after, -1)
      end

      def to_s
        message
      end
    end # Error

    private

    def parse_response http
      case http.response_header.status
        when 200
          http.response
        when 420
          raise Error, code: 420, retry_after: http.response_header['RETRY_AFTER']
        else
          raise Error, code: http.response_header.status
      end
    end

    def hashtags list
      list.select {|text| %r{^#}.match(text)}
    end

    def accounts list
      list.select {|text| %r{^@}.match(text)}
    end
  end # Twitter
end # EM
