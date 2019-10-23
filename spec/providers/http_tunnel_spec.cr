require "../spec_helper"

describe ProxyFetcher::Providers::HTTPTunnel do
  it "fetches proxies" do
    proxies = ProxyFetcher::Providers::HTTPTunnel.fetch_proxies

    proxies.each do |proxy|
      proxy.addr.should match(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/i)
      proxy.port.should be_a(Int32)
      proxy.type.to_s.empty?.should be_false
      proxy.country.to_s.empty?.should be_false
      proxy.anonymity.to_s.empty?.should be_false
    end
  end
end
