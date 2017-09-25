require "helper"

describe Lapidarius::CLI do
  let(:io) { StringIO.new }

  it "must warn if no gem is specified" do
    Lapidarius::CLI.new(%w[sinatra], io).call
    io.string.must_equal "specify gem name as: '-g gem_name'\n"
  end

  it "must print runtime dependencies" do
    Lapidarius::CLI.new(%w[--gem=sinatra], io).call(Stubs::Command)
    io.string.must_equal "sinatra (1.4.7)\n├── rack (~> 1.5)\n├── rack-protection (~> 1.4)\n│   └── rack (>= 0)\n└── tilt (< 3, >= 1.3)\n\n3 runtime, 5 development\n"
  end

  it "must warn about missing gems" do
    Lapidarius::CLI.new(%w[--gem=noent], io).call(Stubs::Command)
    io.string.must_equal "no version of \e[1mnoent\e[0m gem installed\n"
  end

  it "must print the help" do
    begin
      Lapidarius::CLI.new(%w[--help], io).call
    rescue SystemExit
      io.string.must_equal "Usage: lapidarius --gem=sinatra\n    -g, --gem=GEM                    The gem name to scan\n    -h, --help                       Prints this help\n"
    end
  end
end
