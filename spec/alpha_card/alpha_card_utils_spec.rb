#encoding: utf-8
require "spec_helper"

describe AlphaCard::Utils do
  it 'parse query strings correctly' do
    expect(AlphaCard::Utils.parse_query("foo=bar")).to eq("foo" => "bar")
    expect(AlphaCard::Utils.parse_query('cars[]=Saab&cars[]=Audi')).to eq({'cars[]' => ['Saab', 'Audi']})
    expect(AlphaCard::Utils.parse_query("foo=bar&foo=quux")).to eq("foo" => ["bar", "quux"])
    expect(AlphaCard::Utils.parse_query("foo=1&bar=2")).to eq("foo" => "1", "bar" => "2")
    expect(AlphaCard::Utils.parse_query("my+weird+field=q1%212%22%27w%245%267%2Fz8%29%3F")).to eq("my weird field" => "q1!2\"'w$5&7/z8)?")
    expect(AlphaCard::Utils.parse_query("foo%3Dbaz=bar")).to eq("foo=baz" => "bar")
    expect(AlphaCard::Utils.parse_query("=")).to eq("" => "")
    expect(AlphaCard::Utils.parse_query("=value")).to eq("" => "value")
    expect(AlphaCard::Utils.parse_query("key=")).to eq("key" => "")
    expect(AlphaCard::Utils.parse_query("&key&")).to eq("key" => nil)
  end

  it 'unescape the characters correctly' do
    expect(AlphaCard::Utils.unescape('%E9%9F%93', Encoding::UTF_8)).to eq('韓')
    expect(AlphaCard::Utils.unescape("fo%3Co%3Ebar")).to eq("fo<o>bar")
    expect(AlphaCard::Utils.unescape("a+space")).to eq("a space")
    expect(AlphaCard::Utils.unescape("a%20space")).to eq("a space")
    expect(AlphaCard::Utils.unescape("q1%212%22%27w%245%267%2Fz8%29%3F%5C")).to eq("q1!2\"'w$5&7/z8)?\\")
  end
end