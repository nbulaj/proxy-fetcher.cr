module ProxyFetcher
  class HTMLNode
    property node : XML::Node

    def initialize(node)
      @node = node
    end

    def find(selector)
      matching_node = node.xpath_node(selector)
      self.class.new(matching_node) unless matching_node.nil?
    end

    def content_at(*args)
      clear(find(*args).try(&.content))
    end

    def content
      node.content
    end

    def attr(name)
      node[name]?
    end

    def html
      node.inner_text || ""
    end

    private def clear(text : String?)
      return "" if text.nil? || text.empty?

      text.strip.gsub(/[\t]/i, " ")
    end
  end
end
