module ProxyFetcher
  # This class validates list of proxies.
  # Each proxy is validated using <code>ProxyFetcher::ProxyValidator</code>.
  class ProxyListValidator
    # @!attribute [r] proxies
    #   @return [Array<ProxyFetcher::Proxy>] Source array of proxies
    getter proxies : Array(Proxy)

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
      pool_size = ProxyFetcher.config.pool_size
      target_proxies = @proxies.dup
      connectable_proxies = [] of Proxy

      channel = Channel(Proxy).new(pool_size * 2)
      done = Channel(Int32).new(pool_size)

      pool_size.times do
        spawn do
          loop do
            proxy = target_proxies.shift?

            if proxy.nil?
              done.send(0)
              break
            end

            channel.send(proxy) if proxy.connectable?
          end
        end
      end

      loop do
        select
        when proxy = channel.receive
          connectable_proxies << proxy
        when done.receive
          break
        end
      end

      connectable_proxies
    end
  end
end
