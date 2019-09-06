# ProxyFetcher.cr

[![Build Status](https://travis-ci.org/nbulaj/proxy-fetcher.cr.svg?branch=master)](https://travis-ci.org/nbulaj/proxy-fetcher.cr)

Crystal port of awesome Ruby [ProxyFetcher gem](https://github.com/nbulaj/proxy_fetcher)

This lib can help your Crystal application to make HTTP(S) requests using proxies by fetching
and validating actual proxy lists from multiple providers.

It gives you a special `Manager` class that have everything you need to work with proxy lists: load them, validate, 
return random or specific and so on.

## License

`proxy_fetcher` gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) Nikita Bulai (bulajnikita@gmail.com).
