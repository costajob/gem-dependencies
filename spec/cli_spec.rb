require "spec_helper"

describe Lapidarius::CLI do
  let(:io) { StringIO.new }

  it "must raise an error if no gem is specified" do
    -> { Lapidarius::CLI.new([]).call }.must_raise Lapidarius::CLI::NoGemError
  end

  it "must print runtime dependencies" do
    Lapidarius::CLI.new(%w[--gem=sinatra], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7)              3\n------------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\ntilt (< 3, >= 1.3)\n\n"
  end

  it "must print runtime dependencies recursively" do
    Lapidarius::CLI.new(%w[--gem=sinatra --recursive], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7)              3\n------------------------------\nrack (~> 1.5)\nrack-protection (~> 1.4)\n      rack (>= 0)\ntilt (< 3, >= 1.3)\n\n"
  end

  it "must warn about missing gems" do
    Lapidarius::CLI.new(%w[--gem=noent], io).call(Mocks::Command)
    io.string.must_equal "no version of noent gem is installed!\n"
  end

  it "must print the help" do
    begin
      Lapidarius::CLI.new(%w[--help], io).call
    rescue SystemExit
      io.string.must_equal "Usage: ./bin/lapidarius --gem=sinatra --recursive\n    -g, --gem=GEM                    The gem name to scan\n    -r, --recursive                  Print dependencies recursively\n    -v, --version                    Print library version\n    -h, --help                       Prints this help\n"
    end
  end

  it "must print the version" do
    begin
      Lapidarius::CLI.new(%w[--version], io).call
    rescue SystemExit
      io.string.must_equal "#{Lapidarius::VERSION}\n"
    end
  end
end
