module ProxyFetcher
  module Providers
    # FreeProxyListSSL provider class.
    class FreeProxyListSSL < Base
      # Provider URL to fetch proxy list
      def provider_url
        "https://www.sslproxies.org/"
      end

      def xpath
        "//table[./thead/tr/th[contains(text(), 'IP')]]/tbody/tr"
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
          proxy.type = ProxyFetcher::Proxy::Types::HTTPS
        end
      end
    end

    ProxyFetcher::Configuration.register_provider("free_proxy_list_ssl", FreeProxyListSSL)
  end
end
