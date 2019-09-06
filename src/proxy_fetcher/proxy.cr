module ProxyFetcher
  class Proxy
    # @!attribute [rw] addr
    #   @return [String] address (IP or domain)
    property addr : String?

    # @!attribute [rw] port
    #   @return [Integer] port
    property port : Int32?

    # @!attribute [rw] type
    #   @return [String] type (SOCKS, HTTP(S))
    property type : String?

    # @!attribute [rw] country
    #   @return [String] country or country code
    property country : String?

    # @!attribute [rw] anonymity
    #   @return [String] anonymity level (high, elite, transparent, etc)
    property anonymity : String?

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

    {% for type in [Types::HTTP, Types::HTTPS, Types::SOCKS4, Types::SOCKS5] %}
      def {{ type.id.downcase }}?
        of_type?({{ type }})
      end
    {% end %}

    def ssl?
      https? || socks4? || socks5?
    end

    def connectable?
      ProxyFetcher::ProxyValidator.connectable?(addr, port)
    end

    def valid?
      connectable?
    end

    def uri
      URI.new(host: addr, port: port)
    end

    def url(scheme = false)
      if scheme
        URI.new(scheme: type.to_s.downcase, host: addr, port: port).to_s
      else
        uri.to_s
      end
    end

    private def of_type?(value)
      return false if type.nil? || type.to_s.blank?

      type.to_s.upcase.includes?(value)
    end
  end
end
