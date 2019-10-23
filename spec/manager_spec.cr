require "./spec_helper"

describe ProxyFetcher::Manager do
  it "loads proxy list on initialization by default" do
    manager = ProxyFetcher::Manager.new
    manager.proxies.empty?.should be_false
  end

  it "doesn't load proxy list on initialization if `refresh` argument was set to false" do
    manager = ProxyFetcher::Manager.new(refresh: false)
    manager.proxies.empty?.should be_true
  end

  it "returns nothing if proxy list is empty" do
    manager = ProxyFetcher::Manager.new(refresh: false)

    manager.get.should be_nil
    manager.get!.should be_nil
  end

  it "returns random proxy" do
    manager = ProxyFetcher::Manager.new

    proxy = manager.random
    proxy.nil?.should be_false
    proxy.should be_a(ProxyFetcher::Proxy)
  end
end
