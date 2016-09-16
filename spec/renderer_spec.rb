require "spec_helper"

describe Lapidarius::Renderer do
  let(:sinatra) { Lapidarius::Cutter.new(gem: "sinatra", cmd_klass: Mocks::Command).call }
  let(:io) { StringIO.new }

  it "must fail if gem is nil" do
    -> { Lapidarius::Renderer.new(gem: nil) }.must_raise Lapidarius::Renderer::NoEntGemError
  end

  it "must render output" do
    renderer = Lapidarius::Renderer.new(gem: sinatra)
    renderer.call(io)
    io.string.must_equal "\nsinatra (1.4.7)         3\n-------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\ntilt (< 3, >= 1.3)\n\n"
  end

  it "must render output recursively" do
    renderer = Lapidarius::Renderer.new(gem: sinatra, recursive: true)
    renderer.call(io)
    io.string.must_equal "\nsinatra (1.4.7)         3\n-------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\n  rack (>= 0)\ntilt (< 3, >= 1.3)\n\n"
  end
end
