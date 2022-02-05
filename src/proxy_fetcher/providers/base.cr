module ProxyFetcher
  module Providers
    abstract class Base
      def self.fetch_proxies(*args)
        new.fetch_proxies(*args)
      end

      def fetch_proxies
        proxies = load_proxy_list.map { |html_node| build_proxy(html_node) }.compact
        proxies.reject { |proxy| proxy.addr.nil? }
      end

      abstract def provider_url

      def provider_method
        "get"
      end

      def provider_params
        {} of String => String
      end

      def provider_headers
        {} of String => String
      end

      def load_html(url)
        ProxyFetcher::HTTPClient.new(
          url,
          method: provider_method,
          headers: provider_headers,
          params: provider_params
        ).fetch
      end

      def load_document(url)
        html = load_html(url)
        XML.parse_html(html)
      end

      def load_proxy_list
        doc = load_document(provider_url)
        nodes = doc.xpath(xpath)
        return [] of ProxyFetcher::HTMLNode unless nodes.is_a?(XML::NodeSet)

        nodes.map { |node| ProxyFetcher::HTMLNode.new(node) }
      end

      def build_proxy(*args)
        to_proxy(*args)
      rescue error
        puts(
          "Failed to build Proxy object for #{self.class.name} due to error: #{error.message}"
        )

        nil
      end

      abstract def xpath

      # Convert HTML element with proxy info to ProxyFetcher::Proxy instance.
      #
      # Abstract method. Must be implemented in a descendant class
      #
      # @return [Proxy]
      #   new proxy object from the HTML node
      #
      abstract def to_proxy(node)
    end
  end
end
