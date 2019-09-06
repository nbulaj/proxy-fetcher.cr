module ProxyFetcher
  module Providers
    # FreeProxyList provider class.
    class FreeProxyList < Base
      # Provider URL to fetch proxy list
      def provider_url
        "https://free-proxy-list.net/"
      end

      def xpath
        "//table[@id='proxylisttable']/tbody/tr"
      end

      # Converts HTML node (entry of N tags) to <code>ProxyFetcher::Proxy</code>
      # object.
      #
      # @param html_node [Object]
      #   HTML node from the <code>ProxyFetcher::Document</code> DOM model.
      #
      # @return [ProxyFetcher::Proxy]
      #   Proxy object
      #
      def to_proxy(html_node)
        ProxyFetcher::Proxy.new.tap do |proxy|
          proxy.addr = html_node.content_at("td[1]")
          proxy.port = html_node.content_at("td[2]").gsub(/^0+/, "").try(&.to_i)
          proxy.country = html_node.content_at("td[4]")
          proxy.anonymity = html_node.content_at("td[5]")
          proxy.type = parse_type(html_node)
        end
      end

      # Parses HTML node to extract proxy type.
      #
      # @param html_node [Object]
      #   HTML node from the <code>ProxyFetcher::Document</code> DOM model.
      #
      # @return [String]
      #   Proxy type
      #
      private def parse_type(html_node)
        https = html_node.content_at("td[6]")
        https && https.compare("yes", case_insensitive: true).zero? ? ProxyFetcher::Proxy::Types::HTTPS : ProxyFetcher::Proxy::Types::HTTP
      end
    end

    ProxyFetcher::Configuration.register_provider("free_proxy_list", FreeProxyList)
  end
end
