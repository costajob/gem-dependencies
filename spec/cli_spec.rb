require "spec_helper"

describe Lapidarius::CLI do
  let(:io) { StringIO.new }

  it "must warn if no gem is specified" do
    Lapidarius::CLI.new(%w[sinatra], io).call
    io.string.must_equal "specify gem name as: '-g gem_name'\n"
  end

  it "must print runtime dependencies" do
    Lapidarius::CLI.new(%w[--gem=sinatra], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7)              3\n------------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\ntilt (< 3, >= 1.3)\n\n"
  end

  it "must print runtime dependencies recursively" do
    Lapidarius::CLI.new(%w[--gem=sinatra --recursive], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7)              3\n------------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\n      rack (>= 0)\ntilt (< 3, >= 1.3)\n\n"
  end

  it "must print dependencies filtering by version" do
    Lapidarius::CLI.new(%w[--gem=rack --version=2.0], io).call(Mocks::Command)
    io.string.must_equal "\nrack (2.0.1)                 0\n------------------------------\n"
  end

  it "must warn about missing gems" do
    Lapidarius::CLI.new(%w[--gem=noent], io).call(Mocks::Command)
    io.string.must_equal "no version of noent gem is installed!\n"
  end

  it "must print the help" do
    begin
      Lapidarius::CLI.new(%w[--help], io).call
    rescue SystemExit
      io.string.must_equal "Usage: ./bin/lapidarius --gem=sinatra --recursive\n    -g, --gem=GEM                    The gem name to scan\n    -v, --version=VERSION            Specify the gem version\n    -r, --recursive                  Print dependencies recursively\n    -h, --help                       Prints this help\n"
    end
  end

  it "must print the version" do
  end
end
