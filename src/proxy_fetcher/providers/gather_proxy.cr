require "json"

module ProxyFetcher
  module Providers
    # GatherProxy provider class.
    class GatherProxy < Base
      # Provider URL to fetch proxy list
      def provider_url
        "http://www.gatherproxy.com/"
      end

      def xpath
        "//div[@class=\"proxy-list\"]/table/script"
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
        json = parse_json(html_node)

        ProxyFetcher::Proxy.new.tap do |proxy|
          proxy.addr = json["PROXY_IP"].as_s
          proxy.port = json["PROXY_PORT"].as_s.to_i(16)
          proxy.anonymity = json["PROXY_TYPE"].as_s
          proxy.country = json["PROXY_COUNTRY"].as_s
          proxy.type = ProxyFetcher::Proxy::Types::HTTP
        end
      end

      private def parse_json(html_node)
        javascript = html_node.content[/{.+}/im]
        JSON.parse(javascript)
      end
    end

    ProxyFetcher::Configuration.register_provider("gather_proxy", GatherProxy)
  end
end
