# ProxyFetcher.cr

[![Build Status](https://travis-ci.org/nbulaj/proxy-fetcher.cr.svg?branch=master)](https://travis-ci.org/nbulaj/proxy-fetcher.cr)

Crystal port of awesome Ruby [ProxyFetcher gem](https://github.com/nbulaj/proxy_fetcher)

This lib can help your Crystal application to make HTTP(S) requests using proxies by fetching
and validating actual proxy lists from multiple providers.

It gives you a special `Manager` class that have everything you need to work with proxy lists: load them, validate, 
return random or specific and so on.

## Installation

Add this to your application's `shard.yml`:

```
dependencies:
  proxy-fetcher:
    github: nbulaj/proxy-fetcher.cr
```

## Usage

```crystal
require "proxy_fetcher"
```

By default ProxyFetcher uses all the available proxy providers. To get current proxy list without validation you
need to initialize an instance of `ProxyFetcher::Manager` class. During this process ProxyFetcher will automatically load
and parse all the proxies:

```crystal
manager = ProxyFetcher::Manager.new # will immediately load proxy list from the server
manager.proxies

 #=> [#<ProxyFetcher::Proxy:0x00000002879680 @addr="97.77.104.22", @port=3128, @country="USA",
 #     @response_time=5217, @type="HTTP", @anonymity="High">, ... ]
```

You can initialize proxy manager without immediate load of the proxy list from the remote server by passing
`refresh: false` on initialization:

```crystal
manager = ProxyFetcher::Manager.new(refresh: false) # just initialize class instance
manager.proxies

 #=> []
```

`ProxyFetcher::Manager` class is very helpful when you need to manipulate and manager proxies. To get the proxy
from the list you can call `.get` or `.pop` method that will return first proxy and move it to the end of the list.
This methods has some equivalents like `get!` or aliased `pop!` that will return first **connectable** proxy and
move it to the end of the list. They both marked as danger methods because all dead proxies will be removed from the list.

If you need just some random proxy then call `manager.random_proxy` or it's alias `manager.random`.

To clean current proxy list from the dead entries that does not respond to the requests you you need to use `cleanup!`
or `validate!` method:

```crystal
manager.cleanup! # or manager.validate!
```

This action will enumerate proxy list and remove all the entries that doesn't respond by timeout or returns errors.

In order to increase the performance proxy list validation is performed using Ruby threads. By default gem creates a
pool with 10 threads, but you can increase this number by changing `pool_size` configuration option: `ProxyFetcher.config.pool_size = 50`.
Read more in [Proxy validation speed](#proxy-validation-speed) section.

If you need raw proxy URLs (like `host:port`) then you can use `raw_proxies` methods that will return array of strings:

```crystal
manager = ProxyFetcher::Manager.new
manager.raw_proxies

 # => ["97.77.104.22:3128", "94.23.205.32:3128", "209.79.65.140:8080",
 #     "91.217.42.2:8080", "97.77.104.22:80", "165.234.102.177:8080", ...]
```

You don't need to initialize a new manager every time you want to load actual proxy list from the providers. All you
need is to refresh the proxy list by calling `#refresh_list!` (or `#fetch!`) method for your `ProxyFetcher::Manager` instance:

```crystal
manager.refresh_list! # or manager.fetch!

 #=> [#<ProxyFetcher::Proxy:0x00000002879680 @addr="97.77.104.22", @port=3128, @country="USA",
 #     @response_time=5217, @type="HTTP", @anonymity="High">, ... ]
```

## Configuration

ProxyFetcher is very flexible gem. You can configure the most important parts of the library and use your own solutions.

Default configuration looks as follows:

```crystal
ProxyFetcher.configure do |config|
  config.user_agent = ProxyFetcher::Configuration::DEFAULT_USER_AGENT
  config.pool_size = 10
  config.provider_proxies_load_timeout = 30
  config.proxy_validation_timeout = 3
  config.providers = ProxyFetcher::Configuration.registered_providers
end
```

You can change any of the options above.

For example, you can set your custom User-Agent string:

```crystal
ProxyFetcher.configure do |config|
  config.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'
end
```

## Providers

Currently ProxyFetcher can deal with next proxy providers (services):

* Free Proxy List
* Free SSL Proxies
* Proxy Docker
* Gather Proxy
* HTTP Tunnel Genius
* Proxy List
* XRoxy

## License

`proxy_fetcher` is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) Nikita Bulai (bulajnikita@gmail.com).
