require "spec_helper"

describe Lapidarius::Gem do
  let(:minitest) { Lapidarius::Gem.new(name: "minitest", version: "~> 5.4", env: Lapidarius::Env::DEVELOPMENT) }
  let(:rack) { Lapidarius::Gem.new(name: "rack", version: "~> 1.5", deps: [minitest]) }
  let(:rack_protection) { Lapidarius::Gem.new(name: "rack-protection", version: "~> 1.4") }
  let(:tilt) { Lapidarius::Gem.new(name: "tilt", version: "< 3, >= 1.3") }
  let(:sinatra) { Lapidarius::Gem.new(name: "sinatra", version: "1.4.7", deps: [tilt, rack, rack_protection]) }

  it "must factory gem properly" do
    Lapidarius::Gem.factory("Gem i18n-0.7.0").must_equal Lapidarius::Gem.new(name: "i18n", version: "0.7.0")
    Lapidarius::Gem.factory("Gem multi_json-1.12.1").must_equal Lapidarius::Gem.new(name: "multi_json", version: "1.12.1")
    Lapidarius::Gem.factory("Gem rack-app-5.3.2").must_equal Lapidarius::Gem.new(name: "rack-app", version: "5.3.2")
    Lapidarius::Gem.factory("multi_json (>= 1.3.2)").must_equal Lapidarius::Gem.new(name: "multi_json", version: ">= 1.3.2")
    Lapidarius::Gem.factory("tilt (< 3, >= 1.3)").must_equal Lapidarius::Gem.new(name: "tilt", version: "< 3, >= 1.3")
    Lapidarius::Gem.factory("rake (= 10.4.2, development)").must_equal Lapidarius::Gem.new(name: "rake", version: "= 10.4.2", env: Lapidarius::Env::DEVELOPMENT)
  end

  it "must initailize gem" do
    sinatra.must_be_instance_of Lapidarius::Gem
    sinatra.name.must_equal "sinatra"
    sinatra.version.must_equal "1.4.7"
    sinatra.env.must_equal Lapidarius::Env::RUNTIME
  end

  it "must detect runtime dependency" do
    sinatra.deps.must_include tilt
    sinatra.deps(:runtime).must_include tilt
    sinatra.deps(:development).wont_include tilt
  end

  it "must detect development dependency" do
    rack.deps.must_include minitest
    rack.deps(:development).must_include minitest
    rack.deps(:runtime).wont_include minitest
  end

  it "must prevent adding a wrong dependency" do
    -> { sinatra << "tilt" }.must_raise Lapidarius::Gem::KindError
  end

  it "must print single line" do
    sinatra.to_s.must_equal "sinatra (1.4.7, runtime)"
  end

  it "must print dependencies recursively on multiple lines" do
    sinatra.to_s(recursive: true).must_equal "sinatra (1.4.7, runtime)\ntilt (< 3, >= 1.3, runtime)\nrack (~> 1.5, runtime)\n  minitest (~> 5.4, development)\nrack-protection (~> 1.4, runtime)"
  end
end
