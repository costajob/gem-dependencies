require "spec_helper"

describe Lapidarius::Renderer do
  let(:sinatra) { Lapidarius::Cutter.new(gem: "sinatra", include_dev: true, cmd_klass: Mocks::Command).call }
  let(:io) { StringIO.new }

  it "must fail if gem is nil" do
    -> { Lapidarius::Renderer.new(gem: nil) }.must_raise Lapidarius::Renderer::NoEntGemError
  end

  it "must render output" do
    renderer = Lapidarius::Renderer.new(gem: sinatra)
    renderer.call(io)
    io.string.must_equal "\nsinatra (1.4.7):\n\nruntime gems                      3\n-----------------------------------\nrack (~> 1.5, runtime)\nrack-protection (~> 1.4, runtime)\ntilt (< 3, >= 1.3, runtime)\n\ndevelopment gems                  1\n-----------------------------------\nlapidarius (>= 0, development)\n\n"
  end

  it "must render output recursively" do
    renderer = Lapidarius::Renderer.new(gem: sinatra, recursive: true)
    renderer.call(io)
    io.string.must_equal "\nsinatra (1.4.7):\n\nruntime gems                      3\n-----------------------------------\nrack (~> 1.5, runtime)\n  bacon (>= 0, development)\n  rake (>= 0, development)\n    hoe (~> 3.13, development)\n    minitest (~> 5.4, development)\n    hoe (~> 3.14, development)\n    rdoc (~> 4.0, development)\n    rdoc (~> 4.0, development)\nrack-protection (~> 1.4, runtime)\n  rack (>= 0, runtime)\n    bacon (>= 0, development)\n    rake (>= 0, development)\n    hoe (~> 3.13, development)\n    minitest (~> 5.4, development)\n      hoe (~> 3.14, development)\n      rdoc (~> 4.0, development)\n    rdoc (~> 4.0, development)\n  rack-test (>= 0, development)\n  rspec (~> 2.0, development)\ntilt (< 3, >= 1.3, runtime)\n\ndevelopment gems                  1\n-----------------------------------\nlapidarius (>= 0, development)\n  rr (~> 1.5, runtime)\n\n"
  end
end
