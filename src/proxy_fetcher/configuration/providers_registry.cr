module ProxyFetcher
  class ProvidersRegistry
    @@providers = {} of String => ProxyFetcher::Providers::Base.class

    def providers
      @@providers
    end

    def register(name, klass)
      raise Exception.new("#{name} already registered!") if providers.has_key?(name)

      providers[name] = klass
    end

    def class_for(provider_name)
      providers.fetch(provider_name.to_s)
    rescue KeyError
      raise Exception.new("Unknown provider: #{provider_name}")
    end
  end
end
