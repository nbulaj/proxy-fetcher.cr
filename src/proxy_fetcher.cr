require "uri"
require "json"
require "halite"
require "xml"

require "./proxy_fetcher/configuration"
require "./proxy_fetcher/configuration/providers_registry"
require "./proxy_fetcher/proxy"
require "./proxy_fetcher/proxy/validator"
require "./proxy_fetcher/proxy/proxy_list_validator"
require "./proxy_fetcher/html_node"
require "./proxy_fetcher/http_client"
require "./proxy_fetcher/manager"

require "./proxy_fetcher/providers/base"
require "./proxy_fetcher/providers/free_proxy_list"
require "./proxy_fetcher/providers/free_proxy_list_ssl"
require "./proxy_fetcher/providers/gather_proxy"
require "./proxy_fetcher/providers/http_tunnel"
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
