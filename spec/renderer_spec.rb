require "spec_helper"

describe Lapidarius::Renderer do
  let(:sinatra) { Lapidarius::Cutter.new(gem: "sinatra", include_dev: true, cmd_klass: Mocks::Command).call }
  let(:renderer) { Lapidarius::Renderer.new(sinatra) }

  it "must fail if gem is nil" do
    -> { Lapidarius::Renderer.new(nil) }.must_raise Lapidarius::Renderer::NoEntGemError
  end

  it "must render output" do
    renderer.out.must_equal ["\nsinatra (1.4.7):\n\n", "RUNTIME GEMS            3\n-------------------------\n", "rack (~> 1.5)", "rack-protection (~> 1.4)", "tilt (< 3, >= 1.3)", "\n", "DEVELOPMENT GEMS        7\n-------------------------\n", "bacon (>= 0)", "rake (>= 0)", "hoe (~> 3.13)", "minitest (~> 5.4)", "rdoc (~> 4.0)", "rack-test (>= 0)", "rspec (~> 2.0)", "\n"]
  end
end
