require "spec_helper"

describe Lapidarius::Renderer do
  let(:sinatra) { Lapidarius::Cutter.new(gem: "sinatra", include_dev: true, cmd_klass: Mocks::Command).call }
  let(:renderer) { Lapidarius::Renderer.new(sinatra) }

  it "must fail if gem is nil" do
    -> { Lapidarius::Renderer.new(nil) }.must_raise Lapidarius::Renderer::NoEntGemError
  end

  it "must render output" do
    renderer.out.must_equal ["\nsinatra (1.4.7):\n\n", "\nruntime gems            3\n-------------------------\n\n", "rack (~> 1.5, runtime)\n  bacon (>= 0, development)\n  rake (>= 0, development)\n\n", "rack-protection (~> 1.4, runtime)\n  rack (>= 0, runtime)\n  rack-test (>= 0, development)\n  rspec (~> 2.0, development)\n\n", "tilt (< 3, >= 1.3, runtime)\n\n", "\ndevelopment gems        7\n-------------------------\n\n", "bacon (>= 0, development)\n\n", "rake (>= 0, development)\n  hoe (~> 3.13, development)\n  minitest (~> 5.4, development)\n  rdoc (~> 4.0, development)\n\n", "hoe (~> 3.13, development)\n\n", "minitest (~> 5.4, development)\n  hoe (~> 3.14, development)\n  rdoc (~> 4.0, development)\n\n", "rdoc (~> 4.0, development)\n\n", "rack-test (>= 0, development)\n\n", "rspec (~> 2.0, development)\n\n"]
  end
end
