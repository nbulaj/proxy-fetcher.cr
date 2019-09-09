require "benchmark"

module ProxyFetcher
  # ProxyFetcher Manager class for interacting with proxy lists from various providers.
  class Manager
    # @!attribute [r] proxies
    #   @return [Array<ProxyFetcher::Proxy>] An array of proxies
    getter proxies : Array(Proxy)

    # Initialize ProxyFetcher Manager instance for managing proxies
    #
    # refresh: true - load proxy list from the remote server on initialization
    # refresh: false - just initialize the class, proxy list will be empty ([])
    #
    # @return [Manager]
    #
    def initialize(refresh = true, validate = false)
      @proxies = [] of Proxy

      if refresh
        refresh_list!
        cleanup! if validate
      end
    end

    # Update current proxy list using configured providers.
    #
    # @param filters [Hash] providers filters
    #
    def refresh_list!
      @proxies = [] of Proxy
      channel = Channel(Array(Proxy)).new

      ProxyFetcher.config.providers.each do |provider_name|
        spawn do
          provider = ProxyFetcher::Configuration.providers_registry.class_for(provider_name)
          provider_proxies = provider.fetch_proxies

          channel.send(provider_proxies)
        end
      end

      ProxyFetcher.config.providers.each do
        @proxies.concat(channel.receive)
      end

      @proxies
    end

    def fetch!
      refresh_list!
    end

    # Pop just first proxy (and back it to the end of the proxy list).
    #
    # @return [Proxy]
    #   proxy object from the list
    #
    def get
      return if @proxies.empty?

      first_proxy = @proxies.shift
      @proxies << first_proxy

      first_proxy
    end

    def pop
      get
    end

    # Pop first valid proxy (and back it to the end of the proxy list)
    # Invalid proxies will be removed from the list
    #
    # @return [Proxy]
    #   proxy object from the list
    #
    def get!
      index = proxies.find_index(&.connectable?)
      return if index.nil?

      proxy = proxies.delete_at(index)
      tail = proxies[index..-1]

      @proxies = tail << proxy

      proxy
    end

    def pop!
      get!
    end

    # Clean current proxy list from dead proxies (that doesn't respond by timeout)
    #
    # @return [Array<ProxyFetcher::Proxy>]
    #   list of valid proxies
    def cleanup!
      valid_proxies = ProxyListValidator.new(@proxies).validate
      @proxies &= valid_proxies
    end

    def validate!
      cleanup!
    end

    # Returns random proxy
    #
    # @return [Proxy]
    #   random proxy from the loaded list
    #
    def random_proxy
      proxies.sample
    end

    def random
      random_proxy
    end

    # Returns array of proxy URLs (just schema + host + port)
    #
    # @return [Array<String>]
    #   collection of proxies
    #
    def raw_proxies
      proxies.map(&.url)
    end

    # @private No need to put all the attr_readers to the output
    def inspect
      to_s
    end
  end
end
