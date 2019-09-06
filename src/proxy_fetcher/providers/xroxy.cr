module ProxyFetcher
  module Providers
    class XRoxy < Base
      def provider_url
        "https://www.xroxy.com/free-proxy-lists/"
      end

      def xpath
        "//div/table/tbody/tr"
      end

      def to_proxy(html_node)
        ProxyFetcher::Proxy.new.tap do |proxy|
          proxy.addr = html_node.content_at("td[1]")
          proxy.port = html_node.content_at("td[2]").gsub(/^0+/, "").to_i
          proxy.anonymity = html_node.content_at("td[3]")
          proxy.country = html_node.content_at("td[5]")
          proxy.type = html_node.content_at("td[3]")
        end
      end
    end

    ProxyFetcher::Configuration.register_provider("xroxy", ProxyFetcher::Providers::XRoxy)
  end
end
