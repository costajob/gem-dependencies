require "spec_helper"

describe Lapidarius::Command do
  let(:command) { Lapidarius::Command.new(dep_klass: Mocks::Dependency) }

  it "must return gem specification" do
    command.call("sinatra").must_equal "Gem sinatra-1.4.7\n  rack (~> 1.5)\n  rack-protection (~> 1.4)\n  tilt (< 3, >= 1.3)"
  end
end
