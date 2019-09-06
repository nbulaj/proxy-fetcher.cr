module ProxyFetcher
  module Providers
    class XRoxy < Base
      def provider_url
        "https://www.xroxy.com/free-proxy-lists/"
      end

      def load_proxy_list
        doc = load_document(provider_url)
        nodes = doc.xpath("//div/table/tbody/tr")
        return [] of ProxyFetcher::HTMLNode unless nodes.is_a?(XML::NodeSet)

        nodes.map { |node| ProxyFetcher::HTMLNode.new(node) }
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
