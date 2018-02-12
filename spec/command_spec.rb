require "helper"

describe Lapidarius::Command do
  let(:command) { Lapidarius::Command.new(dep_klass: Stubs::Dependency) }

  it "must pass version arguments" do
    command.call("sinatra", "1.4.7")
    command.dep.args.must_equal ["sinatra", "-v", "1.4.7"]
  end

  it "must return gem specification" do
    command.call("sinatra").must_equal "Gem sinatra-1.4.7\n  rack (~> 1.5)\n  rack-protection (~> 1.4)\n  tilt (< 3, >= 1.3)\n  lapidarius (>= 0, development)"
  end
end
