module ProxyFetcher
  class Proxy
    # @!attribute [rw] addr
    #   @return [String] address (IP or domain)
    property addr : String | Nil

    # @!attribute [rw] port
    #   @return [Integer] port
    property port : Int32 | Nil

    # @!attribute [rw] type
    #   @return [String] type (SOCKS, HTTP(S))
    property type : String | Nil

    # @!attribute [rw] country
    #   @return [String] country or country code
    property country : String | Nil

    # @!attribute [rw] anonymity
    #   @return [String] anonymity level (high, elite, transparent, etc)
    property anonymity : String | Nil

    # Proxy types
    module Types
      HTTP   = "HTTP"
      HTTPS  = "HTTPS"
      SOCKS4 = "SOCKS4"
      SOCKS5 = "SOCKS5"
    end

    def initialize(
      @addr = nil,
      @port = nil,
      @type = nil,
      @country = nil,
      @anonymity = nil
    )
    end

    def http?
      of_type?(Types::HTTP)
    end

    def https?
      of_type?(Types::HTTPS)
    end

    def socks4?
      of_type?(Types::SOCKS4)
    end

    def socks5?
      of_type?(Types::SOCKS5)
    end

    def ssl?
      https? || socks4? || socks5?
    end

    def connectable?
      # TODO: implement me!
    end

    def valid?
      connectable?
    end

    def uri
      URI.new(host: addr, port: port)
    end

    def url(scheme = false)
      if scheme
        URI.new(scheme: type, host: addr, port: port).to_s
      else
        URI.new(host: addr, port: port).to_s
      end
    end

    private def of_type?(value)
      return false if type.nil?

      type.to_s.upcase.includes?(value)
    end
  end
end
