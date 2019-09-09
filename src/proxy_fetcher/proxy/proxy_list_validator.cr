module ProxyFetcher
  # This class validates list of proxies.
  # Each proxy is validated using <code>ProxyFetcher::ProxyValidator</code>.
  class ProxyListValidator
    # @!attribute [r] proxies
    #   @return [Array<ProxyFetcher::Proxy>] Source array of proxies
    getter proxies : Array(Proxy)
    # @!attribute [r] valid_proxies
    #   @return [Array<ProxyFetcher::Proxy>] Array of valid proxies after validation
    getter valid_proxies : Array(Proxy)

    # @param [Array<ProxyFetcher::Proxy>] *proxies
    #   Any number of <code>ProxyFetcher::Proxy</code> to validate
    def initialize(proxies = [] of Proxy)
      @proxies = proxies.flatten
      @valid_proxies = [] of Proxy
    end

    # Performs validation
    #
    # @return [Array<ProxyFetcher::Proxy>]
    #   list of valid proxies
    def validate
      target_proxies = @proxies.dup

      # TODO: make it use fibers
      target_proxies.each do |proxy|
        @valid_proxies << proxy if proxy.connectable?
      end

      @valid_proxies
    end
  end
end
