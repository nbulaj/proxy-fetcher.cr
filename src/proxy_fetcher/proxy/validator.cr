# TODO: replace with Halite when proxy will be supported
require "http_proxy"

module ProxyFetcher
  # Default ProxyFetcher proxy validator that checks either proxy
  # connectable or not. It tries to send HEAD request to default
  # URL to check if proxy can be used (aka connectable?).
  class ProxyValidator
    # Default URL that will be used to check if proxy can be used.
    URI_TO_CHECK = URI.parse("https://www.google.com/")

    # Short variant to validate proxy.
    #
    # @param proxy_addr [String] proxy address or IP
    # @param proxy_port [Int32] proxy port
    #
    # @return [Boolean]
    #   true if connection to the server using proxy established, otherwise false
    #
    def self.connectable?(proxy_addr : String, proxy_port : Int32)
      proxy_client = HTTP::Proxy::Client.new(proxy_addr, proxy_port)

      http_client = HTTP::Client.new(URI_TO_CHECK)
      http_client.connect_timeout = ProxyFetcher.config.proxy_validation_timeout
      http_client.read_timeout = ProxyFetcher.config.proxy_validation_timeout
      http_client.set_proxy(proxy_client)
      http_client.tls.verify_mode = OpenSSL::SSL::VerifyMode::NONE

      response = http_client.get("/")
      response.success?
    rescue IO::Timeout | OpenSSL::SSL::Error | IO::Error | Errno
      false
    end

    def self.connectable?(proxy_addr : String?, proxy_port : Int32?)
      false
    end
  end
end
