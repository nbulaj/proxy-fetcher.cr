require "./spec_helper"

describe ProxyFetcher::Proxy do
  it "can initialize a new proxy object" do
    proxy = ProxyFetcher::Proxy.new(addr: "192.169.1.1", port: 8080, type: "HTTP")

    proxy.addr.should eq("192.169.1.1")
    proxy.port.should eq(8080)
    proxy.type.should eq("HTTP")
  end

  it "checks proxy type correctly" do
    proxy = ProxyFetcher::Proxy.new(addr: "192.169.1.1", port: 8080)

    proxy.type = ProxyFetcher::Proxy::Types::HTTP
    proxy.http?.should be_true
    proxy.https?.should be_false
    proxy.ssl?.should be_false

    proxy.type = ProxyFetcher::Proxy::Types::HTTPS
    proxy.https?.should be_true
    proxy.http?.should be_true
    proxy.ssl?.should be_true

    proxy.type = ProxyFetcher::Proxy::Types::SOCKS4
    proxy.socks4?.should be_true
    proxy.ssl?.should be_true

    proxy.type = ProxyFetcher::Proxy::Types::SOCKS5
    proxy.socks5?.should be_true
    proxy.ssl?.should be_true
  end

  it "not connectable if IP addr is wrong" do
    proxy = ProxyFetcher::Proxy.new(addr: "192.168.1.0", port: 8080)
    proxy.connectable?.should be_false
  end

  it "returns URI" do
    proxy = ProxyFetcher::Proxy.new(addr: "192.168.1.0", port: 8080)

    proxy.uri.should be_a(URI)
  end

  it "returns URL" do
    proxy = ProxyFetcher::Proxy.new(addr: "192.168.1.0", port: 8080)
    proxy.url.should eq("//192.168.1.0:8080")
  end

  it "returns URL with scheme" do
    proxy = ProxyFetcher::Proxy.new(addr: "192.168.1.0", port: 8080, type: "HTTPS")
    proxy.url(scheme: true).should eq("https://192.168.1.0:8080")
  end
end
