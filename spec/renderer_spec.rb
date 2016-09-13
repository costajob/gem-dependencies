require "spec_helper"

describe Lapidarius::Renderer do
  let(:sinatra) { Lapidarius::Cutter.new(gem: "sinatra", include_dev: true).call }
  let(:renderer) { Lapidarius::Renderer.new(sinatra) }

  it "must fail if gem is nil" do
    -> { Lapidarius::Renderer.new(nil) }.must_raise Lapidarius::Renderer::NoEntGemError
  end

  it "must render output" do
    renderer.out.must_equal ["\n", "sinatra (1.4.7)\n-------------------------\n", "  runtime gems (installed): 3\n", "  development gems (found): 7\n\n", "runtime gems:\n-------------------------\n", "rack (~> 1.5)\n  bacon (>= 0, development)\n  rake (>= 0, development)\n\n", "rack-protection (~> 1.4)\n  rack (>= 0, runtime)\n  rack-test (>= 0, development)\n  rspec (~> 2.0, development)\n\n", "tilt (< 3, >= 1.3)\n\n", "development gems:\n-------------------------\n", "bacon (>= 0)\n\n", "rake (>= 0)\n  hoe (~> 3.13, development)\n  minitest (~> 5.4, development)\n  rdoc (~> 4.0, development)\n\n", "hoe (~> 3.13)\n\n", "minitest (~> 5.4)\n  hoe (~> 3.14, development)\n  rdoc (~> 4.0, development)\n\n", "rdoc (~> 4.0)\n\n", "rack-test (>= 0)\n\n", "rspec (~> 2.0)\n\n"]
  end
end
