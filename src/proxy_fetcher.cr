require "uri"
require "json"
require "halite"
require "xml"

require "./proxy_fetcher/configuration"
require "./proxy_fetcher/configuration/providers_registry"
require "./proxy_fetcher/proxy"
require "./proxy_fetcher/html_node"
require "./proxy_fetcher/http_client"

require "./proxy_fetcher/providers/base"
require "./proxy_fetcher/providers/xroxy"

module ProxyFetcher
  VERSION = "0.1.0"

  def self.config
    @@config ||= ProxyFetcher::Configuration.new
  end

  def self.configure
    yield config
  end
end

puts "Supported providers: #{ProxyFetcher::Configuration.registered_providers.inspect}"

# p = ProxyFetcher::Providers::XRoxy.new.fetch_proxies!
# puts p.inspect
