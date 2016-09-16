require "spec_helper"

describe Lapidarius::CLI do
  let(:io) { StringIO.new }

  it "must raise an error if no gem is specified" do
    -> { Lapidarius::CLI.new([]).call }.must_raise Lapidarius::CLI::NoGemError
  end

  it "must print runtime dependencies" do
    Lapidarius::CLI.new(%w[--gem=sinatra], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7):\n\nruntime gems                      3\n-----------------------------------\nrack (~> 1.5, runtime)\nrack-protection (~> 1.4, runtime)\ntilt (< 3, >= 1.3, runtime)\n\n"
  end

  it "must print runtime and development dependencies" do
    Lapidarius::CLI.new(%w[--gem=sinatra --development], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7):\n\nruntime gems                      3\n-----------------------------------\nrack (~> 1.5, runtime)\nrack-protection (~> 1.4, runtime)\ntilt (< 3, >= 1.3, runtime)\n\ndevelopment gems                  1\n-----------------------------------\nlapidarius (>= 0, development)\n\n"
  end

  it "must print runtime dependencies recursively" do
    Lapidarius::CLI.new(%w[--gem=sinatra --recursive], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7):\n\nruntime gems                      3\n-----------------------------------\nrack (~> 1.5, runtime)\nrack-protection (~> 1.4, runtime)\n  rack (>= 0, runtime)\ntilt (< 3, >= 1.3, runtime)\n\n"
  end

  it "must print runtime and development dependencies recursively" do
    Lapidarius::CLI.new(%w[--gem=sinatra --recursive --development], io).call(Mocks::Command)
    io.string.must_equal "\nsinatra (1.4.7):\n\nruntime gems                      3\n-----------------------------------\nrack (~> 1.5, runtime)\n  bacon (>= 0, development)\n  rake (>= 0, development)\n    hoe (~> 3.13, development)\n    minitest (~> 5.4, development)\n    hoe (~> 3.14, development)\n    rdoc (~> 4.0, development)\n    rdoc (~> 4.0, development)\nrack-protection (~> 1.4, runtime)\n  rack (>= 0, runtime)\n    bacon (>= 0, development)\n    rake (>= 0, development)\n    hoe (~> 3.13, development)\n    minitest (~> 5.4, development)\n      hoe (~> 3.14, development)\n      rdoc (~> 4.0, development)\n    rdoc (~> 4.0, development)\n  rack-test (>= 0, development)\n  rspec (~> 2.0, development)\ntilt (< 3, >= 1.3, runtime)\n\ndevelopment gems                  1\n-----------------------------------\nlapidarius (>= 0, development)\n  rr (~> 1.5, runtime)\n\n"
  end

  it "must print the help" do
    begin
      Lapidarius::CLI.new(%w[--help], io).call
    rescue SystemExit
      io.string.must_equal "Usage: ./bin/lapidarius --gem=sinatra --recursive --development\n    -g, --gem=GEM                    The gem name to scan\n    -r, --recursive                  Print dependencies recursively\n    -d, --development                Include development dependencies\n    -h, --help                       Prints this help\n"
    end
  end
end
