require "helper"

describe Lapidarius::CLI do
  let(:io) { StringIO.new }

  it "must print nothing if no gem is specified" do
    Lapidarius::CLI.new(nil, io).call
    io.string.strip.must_be_empty
  end

  it "must print runtime dependencies" do
    Lapidarius::CLI.new("sinatra", io, Stubs::Command).call
    io.string.must_equal "sinatra (1.4.7)\n├── rack (~> 1.5)\n├── rack-protection (~> 1.4)\n│   └── rack (>= 0)\n└── tilt (< 3, >= 1.3)\n\n3 runtime, 5 development\n"
  end

  it "must warn about missing gems" do
    Lapidarius::CLI.new("noent", io, Stubs::Command).call
    io.string.must_equal %Q{no version of "noent" gem installed\n}
  end

  it "must print the help" do
    Lapidarius::CLI.new("-h", io).call
    io.string.must_equal "Usage: lapidarius sinatra\n    -h --help               Print this help\n    <gem-name>              Gem's name to cut\n"
  end
end
