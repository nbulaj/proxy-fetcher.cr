module ProxyFetcher
  class HTTPClient
    property url : String

    # @!attribute [r] HTTP method
    #   @return [String] HTTP method verb
    property method : String

    # @!attribute [r] HTTP params
    #   @return [Hash] params
    property params : Hash(String, String)

    # @!attribute [r] HTTP headers
    #   @return [Hash] headers
    property headers : Hash(String, String)

    property timeout : Int32

    def initialize(
      url,
      method = "get",
      @params = {} of String => String,
      @headers = {} of String => String
    )
      @url = url.to_s
      @method = method.to_s.downcase

      @timeout = 5
      @http_client = Halite::Client.new
    end

    def fetch
      response = process_http_request
      response.try(&.body).to_s
    rescue error
      puts "Error fetching #{@url} - #{error.message}"
      ""
    end

    private def process_http_request
      case @method
      when "get"
        @http_client.follow.timeout(connect: timeout, read: timeout).get(@url)
      when "post"
        # TODO: implement me!
      else
        raise Exception.new("Unsupported HTTP method - #{@method}")
      end
    end

    private def default_headers
      {
        "User-Agent" => ProxyFetcher.config.user_agent,
      }
    end
  end
end
