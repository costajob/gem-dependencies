require "spec_helper"

describe Lapidarius::Renderer do
  let(:sinatra) { Lapidarius::Cutter.new("sinatra", Mocks::Command).call }
  let(:io) { StringIO.new }

  it "must fail if gem is nil" do
    -> { Lapidarius::Renderer.new(nil) }.must_raise Lapidarius::Renderer::NoEntGemError
  end

  it "must render output" do
    renderer = Lapidarius::Renderer.new(sinatra)
    renderer.call(io)
    io.string.must_equal "\nsinatra (1.4.7)             \e[1m3\e[0m\n------------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\ntilt (< 3, >= 1.3)\n\n"
  end

  it "must render output recursively" do
    renderer = Lapidarius::Renderer.new(sinatra, true)
    renderer.call(io)
    io.string.must_equal "\nsinatra (1.4.7)             \e[1m3\e[0m\n------------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\n      rack (>= 0)\ntilt (< 3, >= 1.3)\n\n"
  end
end
