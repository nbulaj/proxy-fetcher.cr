require "json"

module ProxyFetcher
  module Providers
    class Proxypedia < Base
      def provider_url
        "https://proxypedia.org"
      end

      def xpath
        "//main/ul/li[position()>1]"
      end

      def to_proxy(html_node)
        addr, port = html_node.content_at("a").to_s.split(":")

        ProxyFetcher::Proxy.new.tap do |proxy|
          proxy.addr = addr
          proxy.port = port.to_i
          proxy.country = parse_country(html_node)
          proxy.anonymity = "Unknown"
          proxy.type = ProxyFetcher::Proxy::Types::HTTP
        end
      end

      private def parse_country(html_node)
        text = html_node.content.to_s
        text[/\((.+?)\)/, 1] || "Unknown"
      end
    end

    ProxyFetcher::Configuration.register_provider("proxypedia", ProxyFetcher::Providers::Proxypedia)
  end
end
