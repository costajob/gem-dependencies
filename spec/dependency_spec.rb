require "spec_helper"

describe GemDependencies::Dependency do
  it "must define types constants" do
    GemDependencies::Dependency::Type::RUNTIME.must_equal "runtime"
    GemDependencies::Dependency::Type::DEVELOPMENT.must_equal "development"
  end

  it "must initailize dependency" do
    dep = GemDependencies::Dependency.new(name: "sinatra", version: "1.4.7")
    dep.must_be_instance_of GemDependencies::Dependency
    dep.name.must_equal "sinatra"
    dep.version.must_equal "1.4.7"
    dep.type.must_equal GemDependencies::Dependency::Type::RUNTIME
  end

  it "must factory dependency properly" do
    GemDependencies::Dependency.factory("Gem sinatra-1.4.7").must_equal GemDependencies::Dependency.new(name: "sinatra", version: "1.4.7")
    GemDependencies::Dependency.factory("Gem multi_json-1.12.1").must_equal GemDependencies::Dependency.new(name: "multi_json", version: "1.12.1")
    GemDependencies::Dependency.factory("Gem rack-app-5.3.2").must_equal GemDependencies::Dependency.new(name: "rack-app", version: "5.3.2")
    GemDependencies::Dependency.factory("multi_json (>= 1.3.2)").must_equal GemDependencies::Dependency.new(name: "multi_json", version: ">= 1.3.2")
    GemDependencies::Dependency.factory("tilt (< 3, >= 1.3)").must_equal GemDependencies::Dependency.new(name: "tilt", version: "< 3, >= 1.3")
    GemDependencies::Dependency.factory("rake (= 10.4.2, development)").must_equal GemDependencies::Dependency.new(name: "rake", version: "= 10.4.2", type: "development")
  end
end
