require "helper"

describe Lapidarius::Gem do
  let(:sinatra) { Stubs::Gems.sinatra }

  it "must factory gem properly" do
    Lapidarius::Gem.factory("Gem rails-5.2.0.rc1").must_equal Lapidarius::Gem.new(name: "rails", version: "5.2.0.rc1")
    Lapidarius::Gem.factory("Gem rails-5.2.0.beta2").must_equal Lapidarius::Gem.new(name: "rails", version: "5.2.0.beta2")
    Lapidarius::Gem.factory("Gem multi_json-1.12.1").must_equal Lapidarius::Gem.new(name: "multi_json", version: "1.12.1")
    Lapidarius::Gem.factory("Gem rack-app-5.3.2").must_equal Lapidarius::Gem.new(name: "rack-app", version: "5.3.2")
    Lapidarius::Gem.factory("Gem lapidarius-1.0").must_equal Lapidarius::Gem.new(name: "lapidarius", version: "1.0")
    Lapidarius::Gem.factory("Gem RubyInline-3.12.4").must_equal Lapidarius::Gem.new(name: "RubyInline", version: "3.12.4")
    Lapidarius::Gem.factory("Gem http_parser.rb-0.6.0").must_equal Lapidarius::Gem.new(name: "http_parser.rb", version: "0.6.0")
    Lapidarius::Gem.factory("actionmodel (= 5.2.0.rc1)").must_equal Lapidarius::Gem.new(name: "actionmodel", version: "= 5.2.0.rc1")
    Lapidarius::Gem.factory("multi_json (>= 1.3.2)").must_equal Lapidarius::Gem.new(name: "multi_json", version: ">= 1.3.2")
    Lapidarius::Gem.factory("ZenTest (~> 4.3)").must_equal Lapidarius::Gem.new(name: "ZenTest", version: "~> 4.3")
    Lapidarius::Gem.factory("tilt (< 3, >= 1.3)").must_equal Lapidarius::Gem.new(name: "tilt", version: "< 3, >= 1.3")
  end

  it "must raise an error when gem is missing" do
    -> { Lapidarius::Gem.factory("No gems found matching noent (>= 0)") }.must_raise Lapidarius::Gem::NotInstalledError
  end

  it "must delegate size method" do
    sinatra.size.must_equal 3
  end

  it "must delegate each_with_index method" do
    sinatra.each_with_index do |dep, _|
      dep.must_be_instance_of Lapidarius::Gem
    end
  end

  it "must initailize gem" do
    sinatra.must_be_instance_of Lapidarius::Gem
    sinatra.name.must_equal "sinatra"
    sinatra.version.must_equal "1.4.7"
  end

  it "must be represented as a string" do
    sinatra.to_s.must_equal "sinatra (1.4.7)"
  end

  it "must count flat dependencies" do
    sinatra.count.must_equal 4
  end

  it "must prevent adding a wrong dependency" do
    -> { sinatra << "tilt" }.must_raise Lapidarius::Gem::KindError
  end
end
