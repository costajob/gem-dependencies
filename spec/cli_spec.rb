require "spec_helper"

describe Lapidarius::CLI do
  let(:io) { StringIO.new }

  it "must warn if no gem is specified" do
    Lapidarius::CLI.new(%w[sinatra], io).call
    io.string.must_equal "specify gem name as: '-g gem_name'\n"
  end

  it "must print runtime dependencies" do
    Lapidarius::CLI.new(%w[--gem=sinatra], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7)             \e[1m3\e[0m\n------------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\ntilt (< 3, >= 1.3)\n\n"
  end

  it "must print runtime dependencies recursively" do
    Lapidarius::CLI.new(%w[--gem=sinatra --recursive], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7)             \e[1m3\e[0m\n------------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\n      rack (>= 0)\ntilt (< 3, >= 1.3)\n\n"
  end

  it "must warn about missing gems" do
    Lapidarius::CLI.new(%w[--gem=noent], io).call(Mocks::Command)
    io.string.must_equal "no version of \e[1mnoent\e[0m gem installed\n"
  end

  it "must print the help" do
    begin
      Lapidarius::CLI.new(%w[--help], io).call
    rescue SystemExit
      io.string.must_equal "Usage: ./bin/lapidarius --gem=sinatra --recursive\n    -g, --gem=GEM                    The gem name to scan\n    -r, --recursive                  Print dependencies recursively\n    -h, --help                       Prints this help\n"
    end
  end
end
