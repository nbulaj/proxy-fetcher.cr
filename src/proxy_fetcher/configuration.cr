module ProxyFetcher
  class Configuration
    property client_timeout : Int32
    property provider_proxies_load_timeout : Int32
    property proxy_validation_timeout : Int32
    property pool_size : Int32
    property user_agent : String
    property providers : Array(String)

    # User-Agent string that will be used by the ProxyFetcher HTTP client (to
    # send requests via proxy) and to fetch proxy lists from the sources.
    #
    # Default is Google Chrome 60, but can be changed in <code>ProxyFetcher.config</code>.
    #
    DEFAULT_USER_AGENT = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 " \
                         "(KHTML, like Gecko) Chrome/60.0.3112 Safari/537.36"

    def initialize
      @user_agent = DEFAULT_USER_AGENT
      @pool_size = 10
      @client_timeout = 3
      @provider_proxies_load_timeout = 30
      @proxy_validation_timeout = 3
      @providers = self.class.registered_providers
    end

    def self.providers_registry
      @@providers_registry ||= ProxyFetcher::ProvidersRegistry.new
    end

    # Register new proxy provider. Requires provider name and class
    # that will process proxy list.
    #
    # @param name [String, Symbol]
    #   name of the provider
    #
    # @param klass [Class]
    #   Class that will fetch and process proxy list
    #
    def self.register_provider(name, klass)
      providers_registry.register(name, klass)
    end

    # Returns registered providers names.
    #
    # @return [Array<String>, Array<Symbol>]
    #   registered providers names
    #
    def self.registered_providers
      providers_registry.providers.keys
    end
  end
end
